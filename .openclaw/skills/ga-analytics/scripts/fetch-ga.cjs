const { BetaAnalyticsDataClient } = require("@google-analytics/data");

const credentialsBase64 = process.env.GA_CREDENTIALS_BASE64;
const propertyId = process.env.GA_PROPERTY_ID;

if (!credentialsBase64 || !propertyId) {
  console.error(JSON.stringify({ error: "Missing GA_CREDENTIALS_BASE64 or GA_PROPERTY_ID" }));
  process.exit(1);
}

let credentials;
try {
  const decoded = Buffer.from(credentialsBase64, "base64").toString("utf-8");
  credentials = JSON.parse(decoded);
} catch (e) {
  console.error(JSON.stringify({ error: "Failed to decode credentials: " + e.message }));
  process.exit(1);
}

const analyticsDataClient = new BetaAnalyticsDataClient({ credentials });

const today = new Date();
const yesterday = new Date(today);
yesterday.setDate(yesterday.getDate() - 1);
const weekAgo = new Date(yesterday);
weekAgo.setDate(weekAgo.getDate() - 7);

const formatDate = (date) => date.toISOString().split("T")[0];

function calcChange(current, previous) {
  if (previous === 0) return current > 0 ? 100 : 0;
  return Math.round(((current - previous) / previous) * 100);
}

function formatChange(change) {
  if (change > 0) return "↑ " + change + "%";
  if (change < 0) return "↓ " + Math.abs(change) + "%";
  return "→ 0%";
}

async function fetchMetrics(client, propertyId, dateRange) {
  const [response] = await client.runReport({
    property: "properties/" + propertyId,
    dateRanges: [dateRange],
    metrics: [
      { name: "activeUsers" },
      { name: "newUsers" },
      { name: "sessions" },
      { name: "screenPageViews" },
    ],
  });

  const row = response.rows && response.rows[0];
  if (!row) {
    return { users: 0, newUsers: 0, sessions: 0, pageviews: 0 };
  }

  return {
    users: parseInt(row.metricValues[0].value || 0),
    newUsers: parseInt(row.metricValues[1].value || 0),
    sessions: parseInt(row.metricValues[2].value || 0),
    pageviews: parseInt(row.metricValues[3].value || 0),
  };
}

async function fetchTopPages(client, propertyId, startDate, endDate) {
  const [response] = await client.runReport({
    property: "properties/" + propertyId,
    dateRanges: [{ startDate, endDate }],
    dimensions: [{ name: "pagePath" }],
    metrics: [{ name: "screenPageViews" }, { name: "activeUsers" }],
    orderBys: [{ metric: { metricName: "screenPageViews" }, desc: true }],
    limit: 5,
  });

  return (response.rows || []).map(row => ({
    path: row.dimensionValues[0].value,
    pageviews: parseInt(row.metricValues[0].value || 0),
    users: parseInt(row.metricValues[1].value || 0),
  }));
}

async function fetchTopSources(client, propertyId, startDate, endDate) {
  const [response] = await client.runReport({
    property: "properties/" + propertyId,
    dateRanges: [{ startDate, endDate }],
    dimensions: [{ name: "sessionDefaultChannelGroup" }],
    metrics: [{ name: "activeUsers" }, { name: "sessions" }],
    orderBys: [{ metric: { metricName: "activeUsers" }, desc: true }],
    limit: 5,
  });

  return (response.rows || []).map(row => ({
    channel: row.dimensionValues[0].value,
    users: parseInt(row.metricValues[0].value || 0),
    sessions: parseInt(row.metricValues[1].value || 0),
  }));
}

async function fetchReport() {
  try {
    const yesterdayStr = formatDate(yesterday);
    const weekAgoStr = formatDate(weekAgo);
    const weekAgoPlus1 = formatDate(new Date(weekAgo.getTime() + 86400000));

    const yesterdayMetrics = await fetchMetrics(analyticsDataClient, propertyId, { startDate: yesterdayStr, endDate: yesterdayStr });
    const weekAgoMetrics = await fetchMetrics(analyticsDataClient, propertyId, { startDate: weekAgoStr, endDate: weekAgoPlus1 });
    const topPages = await fetchTopPages(analyticsDataClient, propertyId, yesterdayStr, yesterdayStr);
    const topSources = await fetchTopSources(analyticsDataClient, propertyId, yesterdayStr, yesterdayStr);

    const result = {
      date: yesterdayStr,
      comparedTo: weekAgoStr,
      metrics: {
        users: {
          value: yesterdayMetrics.users,
          previous: weekAgoMetrics.users,
          change: calcChange(yesterdayMetrics.users, weekAgoMetrics.users),
          changeText: formatChange(calcChange(yesterdayMetrics.users, weekAgoMetrics.users)),
        },
        sessions: {
          value: yesterdayMetrics.sessions,
          previous: weekAgoMetrics.sessions,
          change: calcChange(yesterdayMetrics.sessions, weekAgoMetrics.sessions),
          changeText: formatChange(calcChange(yesterdayMetrics.sessions, weekAgoMetrics.sessions)),
        },
        pageviews: {
          value: yesterdayMetrics.pageviews,
          previous: weekAgoMetrics.pageviews,
          change: calcChange(yesterdayMetrics.pageviews, weekAgoMetrics.pageviews),
          changeText: formatChange(calcChange(yesterdayMetrics.pageviews, weekAgoMetrics.pageviews)),
        },
        newUsers: {
          value: yesterdayMetrics.newUsers,
          previous: weekAgoMetrics.newUsers,
          change: calcChange(yesterdayMetrics.newUsers, weekAgoMetrics.newUsers),
          changeText: formatChange(calcChange(yesterdayMetrics.newUsers, weekAgoMetrics.newUsers)),
        },
      },
      topPages,
      topSources,
    };

    console.log(JSON.stringify(result, null, 2));
  } catch (error) {
    console.error(JSON.stringify({ error: error.message, stack: error.stack }));
    process.exit(1);
  }
}

fetchReport();
