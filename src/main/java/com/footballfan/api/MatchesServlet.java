package com.footballfan.api;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

@WebServlet("/api/matches")
public class MatchesServlet extends HttpServlet {

    private static final String API_URL =
            "https://api.football-data.org/v4/competitions/WC/matches?season=2026";

    private static final long CACHE_TIME_MS = 5 * 60 * 1000;

    private final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(10))
            .build();

    private volatile String cachedResponse;
    private volatile long cacheTime;

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String apiToken = System.getenv("FOOTBALL_DATA_TOKEN");

        if (apiToken == null || apiToken.isBlank()) {
            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            response.getWriter().write(
                    "{\"error\":\"Football data token is not configured.\"}"
            );
            return;
        }

        long currentTime = System.currentTimeMillis();

        if (cachedResponse != null &&
                currentTime - cacheTime < CACHE_TIME_MS) {

            response.getWriter().write(cachedResponse);
            return;
        }

        HttpRequest apiRequest = HttpRequest.newBuilder()
                .uri(URI.create(API_URL))
                .timeout(Duration.ofSeconds(20))
                .header("X-Auth-Token", apiToken)
                .GET()
                .build();

        try {
            HttpResponse<String> apiResponse = httpClient.send(
                    apiRequest,
                    HttpResponse.BodyHandlers.ofString()
            );

            if (apiResponse.statusCode() != 200) {
                response.setStatus(HttpServletResponse.SC_BAD_GATEWAY);
                response.getWriter().write(
                        "{\"error\":\"Football provider returned status "
                                + apiResponse.statusCode() + ".\"}"
                );
                return;
            }

            cachedResponse = apiResponse.body();
            cacheTime = currentTime;

            response.getWriter().write(cachedResponse);

        } catch (InterruptedException exception) {
            Thread.currentThread().interrupt();

            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
            );
            response.getWriter().write(
                    "{\"error\":\"Football request was interrupted.\"}"
            );

        } catch (Exception exception) {
            response.setStatus(HttpServletResponse.SC_BAD_GATEWAY);
            response.getWriter().write(
                    "{\"error\":\"Unable to retrieve football matches.\"}"
            );
        }
    }
}
