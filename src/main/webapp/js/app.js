const contextPath = window.footballFanHub.contextPath;
const fixtureList = document.getElementById("fixture-list");
const loadingMessage = document.getElementById("loading-message");
const errorMessage = document.getElementById("error-message");
const filterButtons = document.querySelectorAll(".filter-button");

let matches = [];
let selectedFilter = "all";

function classifyStatus(status) {
    if (["IN_PLAY", "PAUSED", "LIVE"].includes(status)) {
        return "live";
    }

    if (status === "FINISHED") {
        return "finished";
    }

    return "upcoming";
}

function statusLabel(match) {
    const status = classifyStatus(match.status);

    if (status === "live") {
        return "LIVE";
    }

    if (status === "finished") {
        return "FULL TIME";
    }

    return "UPCOMING";
}

function statusClass(match) {
    return `status-${classifyStatus(match.status)}`;
}

function formatKickoff(utcDate) {
    return new Intl.DateTimeFormat("en-IN", {
        day: "numeric",
        month: "short",
        hour: "numeric",
        minute: "2-digit",
        timeZone: "Asia/Kolkata",
        timeZoneName: "short"
    }).format(new Date(utcDate));
}

function formatGroup(group) {
    if (!group) {
        return "World Cup";
    }

    return group.replace("_", " ");
}

function displayScore(match) {
    const score = match.score?.fullTime;

    if (score?.home == null || score?.away == null) {
        return '<span class="score versus">VS</span>';
    }

    return `<span class="score">${score.home} - ${score.away}</span>`;
}

function createDetails(match) {
    const type = classifyStatus(match.status);
    const score = match.score?.fullTime;

    if (type === "finished") {
        const result =
            score?.home === score?.away
                ? "Match ended in a draw"
                : `${score.home > score.away
                    ? match.homeTeam.name
                    : match.awayTeam.name} won`;

        return `
            <div class="detail-line">
                <span class="detail-label">Result</span>
                <strong>${result}</strong>
            </div>

            <div class="detail-line">
                <span class="detail-label">Full time</span>
                <span>${score.home} - ${score.away}</span>
            </div>

            <div class="detail-line">
                <span class="detail-label">Half time</span>
                <span>
                    ${match.score?.halfTime?.home ?? 0}
                    -
                    ${match.score?.halfTime?.away ?? 0}
                </span>
            </div>
        `;
    }

    if (type === "live") {
        return `
            <div class="detail-line">
                <span class="detail-label">Status</span>
                <strong>Match in progress</strong>
            </div>

            <div class="detail-line">
                <span class="detail-label">Score</span>
                <span>${score?.home ?? 0} - ${score?.away ?? 0}</span>
            </div>

            <div class="detail-line">
                <span class="detail-label">Updated</span>
                <span>${formatKickoff(match.lastUpdated)}</span>
            </div>
        `;
    }

    return `
        <div class="detail-line">
            <span class="detail-label">Kickoff</span>
            <strong>${formatKickoff(match.utcDate)}</strong>
        </div>

        <div class="detail-line">
            <span class="detail-label">Stage</span>
            <span>${formatGroup(match.stage)}</span>
        </div>

        <div class="detail-line">
            <span class="detail-label">Group</span>
            <span>${formatGroup(match.group)}</span>
        </div>
    `;
}

function createFixture(match) {
    const status = classifyStatus(match.status);

    return `
        <article class="fixture" data-status="${status}">
            <button class="fixture-button" type="button">
                <span class="fixture-top">
                    <span class="match-status ${statusClass(match)}">
                        ${statusLabel(match)}
                    </span>

                    <span class="match-date">
                        ${status === "upcoming"
                            ? formatKickoff(match.utcDate)
                            : formatGroup(match.group)}
                    </span>
                </span>

                <span class="teams">
                    <span class="team">
                        <img class="flag"
                             src="${match.homeTeam.crest}"
                             alt="${match.homeTeam.name}">
                        <span>${match.homeTeam.shortName}</span>
                    </span>

                    ${displayScore(match)}

                    <span class="team">
                        <span>${match.awayTeam.shortName}</span>
                        <img class="flag"
                             src="${match.awayTeam.crest}"
                             alt="${match.awayTeam.name}">
                    </span>
                </span>

                <span class="hint">Tap to view match details</span>
            </button>

            <div class="fixture-details">
                <div class="details-box">
                    ${createDetails(match)}
                </div>
            </div>
        </article>
    `;
}

function renderMatches() {
    const visibleMatches = matches.filter(match => {
        return selectedFilter === "all" ||
            classifyStatus(match.status) === selectedFilter;
    });

    fixtureList.innerHTML = visibleMatches
        .map(createFixture)
        .join("");

    document.querySelectorAll(".fixture-button").forEach(button => {
        button.addEventListener("click", () => {
            button.closest(".fixture").classList.toggle("open");
        });
    });
}

filterButtons.forEach(button => {
    button.addEventListener("click", () => {
        filterButtons.forEach(item => item.classList.remove("active"));
        button.classList.add("active");
        selectedFilter = button.dataset.filter;
        renderMatches();
    });
});

async function loadMatches() {
    try {
        const response = await fetch(`${contextPath}/api/matches`);

        if (!response.ok) {
            throw new Error("Unable to load the fixtures.");
        }

        const data = await response.json();

        matches = data.matches.sort(
            (first, second) =>
                new Date(first.utcDate) - new Date(second.utcDate)
        );

        loadingMessage.hidden = true;
        renderMatches();

    } catch (error) {
        loadingMessage.hidden = true;
        errorMessage.hidden = false;
        errorMessage.textContent =
            "Fixtures could not be loaded. Please try again shortly.";
    }
}

loadMatches();
