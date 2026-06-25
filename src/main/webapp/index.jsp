<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>World Cup Fan Hub</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">
</head>

<body>

<header>
    <h1 class="logo">⚽ World Cup Fan Hub</h1>
    <p class="tagline">
        Real fixtures, scores and match results
    </p>
</header>

<main class="container">

    <nav class="filters" aria-label="Fixture filters">
       <button class="filter-button active"
        data-filter="today">Today</button>

<button class="filter-button"
        data-filter="all">All</button>

        <button class="filter-button"
                data-filter="live">Live</button>

        <button class="filter-button"
                data-filter="upcoming">Upcoming</button>

        <button class="filter-button"
                data-filter="finished">Results</button>
<button class="filter-button"
        id="standingsBtn">
    Standings
</button>
    </nav>

    <h2 class="section-title">2026 World Cup matches</h2>

    <div id="loading-message" class="details-box">
        Loading real World Cup fixtures…
    </div>

    <div id="error-message"
         class="details-box"
         hidden>
    </div>

    <section id="fixture-list"></section>
<section id="standings-section" hidden>

    <h2 class="section-title">Group Standings</h2>

    <div id="standings-container" class="details-box">
        Loading standings...
    </div>

</section>
</main>

<script>
    window.footballFanHub = {
        contextPath: "${pageContext.request.contextPath}"
    };
</script>

<script src="${pageContext.request.contextPath}/js/app.js"></script>

</body>
</html>
