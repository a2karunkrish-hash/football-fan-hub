<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>World Cup Fan Hub</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

<header>
    <h1 class="logo">⚽ World Cup Fan Hub</h1>
    <p class="tagline">Fixtures, live scores and match results</p>
</header>

<main class="container">

    <nav class="filters" aria-label="Fixture filters">
        <button class="filter-button active" data-filter="all">All</button>
        <button class="filter-button" data-filter="live">Live</button>
        <button class="filter-button" data-filter="upcoming">Upcoming</button>
        <button class="filter-button" data-filter="finished">Results</button>
    </nav>

    <h2 class="section-title">World Cup matches</h2>

    <!-- Sample live match -->
    <article class="fixture" data-status="live">
        <button class="fixture-button" type="button">
            <span class="fixture-top">
                <span class="match-status status-live">LIVE · 67'</span>
                <span class="match-date">Group A</span>
            </span>

            <span class="teams">
                <span class="team">
                    <span class="flag">🇧🇷</span>
                    <span>Brazil</span>
                </span>

                <span class="score">2 - 1</span>

                <span class="team">
                    <span>Germany</span>
                    <span class="flag">🇩🇪</span>
                </span>
            </span>

            <span class="hint">Tap to view match details</span>
        </button>

        <div class="fixture-details">
            <div class="details-box">
                <div class="detail-line">
                    <span class="detail-label">Status</span>
                    <strong>Match in progress · 67th minute</strong>
                </div>

                <div class="detail-line">
                    <span class="detail-label">Goals</span>
                    <span>Vinícius Jr 18', Havertz 41', Rodrygo 59'</span>
                </div>

                <div class="detail-line">
                    <span class="detail-label">Venue</span>
                    <span>MetLife Stadium</span>
                </div>
            </div>
        </div>
    </article>

    <!-- Sample future match -->
    <article class="fixture" data-status="upcoming">
        <button class="fixture-button" type="button">
            <span class="fixture-top">
                <span class="match-status status-upcoming">UPCOMING</span>
                <span class="match-date">28 June · 20:30 IST</span>
            </span>

            <span class="teams">
                <span class="team">
                    <span class="flag">🇦🇷</span>
                    <span>Argentina</span>
                </span>

                <span class="score versus">VS</span>

                <span class="team">
                    <span>France</span>
                    <span class="flag">🇫🇷</span>
                </span>
            </span>

            <span class="hint">Tap to view venue and kickoff</span>
        </button>

        <div class="fixture-details">
            <div class="details-box">
                <div class="detail-line">
                    <span class="detail-label">Kickoff</span>
                    <strong>28 June 2026 · 8:30 PM IST</strong>
                </div>

                <div class="detail-line">
                    <span class="detail-label">Venue</span>
                    <span>Hard Rock Stadium, Miami</span>
                </div>

                <div class="detail-line">
                    <span class="detail-label">Stage</span>
                    <span>Group B</span>
                </div>
            </div>
        </div>
    </article>

    <!-- Sample completed match -->
    <article class="fixture" data-status="finished">
        <button class="fixture-button" type="button">
            <span class="fixture-top">
                <span class="match-status status-finished">FULL TIME</span>
                <span class="match-date">25 June · Group C</span>
            </span>

            <span class="teams">
                <span class="team">
                    <span class="flag">🏴</span>
                    <span>England</span>
                </span>

                <span class="score">3 - 1</span>

                <span class="team">
                    <span>Spain</span>
                    <span class="flag">🇪🇸</span>
                </span>
            </span>

            <span class="hint">Tap to view result and goals</span>
        </button>

        <div class="fixture-details">
            <div class="details-box">
                <div class="detail-line">
                    <span class="detail-label">Result</span>
                    <strong>England won 3–1</strong>
                </div>

                <div class="detail-line">
                    <span class="detail-label">England</span>
                    <span>Kane 14', Saka 52', Bellingham 81'</span>
                </div>

                <div class="detail-line">
                    <span class="detail-label">Spain</span>
                    <span>Yamal 36'</span>
                </div>
            </div>
        </div>
    </article>

</main>

<script>
    const fixtures = document.querySelectorAll(".fixture");
    const filterButtons = document.querySelectorAll(".filter-button");

    fixtures.forEach(fixture => {
        const fixtureButton = fixture.querySelector(".fixture-button");

        fixtureButton.addEventListener("click", () => {
            fixture.classList.toggle("open");
        });
    });

    filterButtons.forEach(button => {
        button.addEventListener("click", () => {
            filterButtons.forEach(item => item.classList.remove("active"));
            button.classList.add("active");

            const selectedFilter = button.dataset.filter;

            fixtures.forEach(fixture => {
                const shouldDisplay =
                    selectedFilter === "all" ||
                    fixture.dataset.status === selectedFilter;

                fixture.style.display = shouldDisplay ? "block" : "none";
            });
        });
    });
</script>

</body>
</html>
