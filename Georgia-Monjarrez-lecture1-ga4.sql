-- BigQuery SQL Lecture 1
-- Author: Georgia Monjarrez
-- GoogleSQL / Standard SQL
-- Source: Lecture 1 screenshots supplied for the assignment.
-- Run each numbered statement separately to capture its results.

-- Query 01: Selecting columns and limiting rows
-- Selects the event date and event name from the daily event tables and returns at most 20 rows. Each row represents an event. Without ORDER BY, the selected rows and their order are not guaranteed. LIMIT restricts the output, but does not by itself restrict which daily tables are scanned.
SELECT event_date, event_name
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
LIMIT 20;

-- Query 02: Filtering purchase events
-- Keeps only purchase events and returns at most 50 rows with the date, event name, and pseudonymous user identifier. A user can appear more than once because these are event rows, not distinct users. The query does not specify an output order.
SELECT event_date, event_name, user_pseudo_id
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
LIMIT 50;

-- Query 03: Sorting purchases by timestamp
-- Returns the 20 most recent purchase events in the sample, ordered from the largest event timestamp to the smallest. GA4 stores event_timestamp as microseconds since the Unix epoch. Events with equal timestamps may appear in either order.
SELECT event_date, event_timestamp, event_name
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
ORDER BY event_timestamp DESC
LIMIT 20;

-- Query 04: Converting timestamps for readability
-- Converts the microsecond timestamp to a readable TIMESTAMP named event_time and returns the 10 most recent events. This example includes all event types because it has no purchase filter. TIMESTAMP represents an absolute point in time; the default BigQuery display is UTC.
SELECT TIMESTAMP_MICROS(event_timestamp) AS event_time,
       event_name
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
ORDER BY event_timestamp DESC
LIMIT 10;

-- Query 05: Counting all December events
-- Counts all event rows in the daily tables for December 1 through December 31, 2020, inclusive. The result has one row and one column, event_count. It measures recorded events, not distinct people or sessions.
SELECT COUNT(*) AS event_count
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201201' AND '20201231';

-- Query 06: Counting December purchases
-- Counts event rows named purchase in the December 2020 daily tables. The single value purchase_events is a count of purchase events; this query does not calculate revenue or count distinct transaction identifiers.
SELECT COUNT(*) AS purchase_events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'purchase'
  AND _TABLE_SUFFIX BETWEEN '20201201' AND '20201231';

-- Query 07: Grouping events by day
-- Counts events separately for each event_date in the December tables. Each output row represents one date, with its total recorded events. Ascending date order makes daily activity easier to compare. Dates with no rows would not appear.
SELECT event_date, COUNT(*) AS events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201201' AND '20201231'
GROUP BY event_date
ORDER BY event_date;

-- Query 08: Ranking the top event types
-- Counts December events by event name, sorts the counts from highest to lowest, and returns at most 15 event types. Each row represents a type of event, rather than an individual event. Tied counts have no specified secondary order.
SELECT event_name, COUNT(*) AS events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201201' AND '20201231'
GROUP BY event_name
ORDER BY events DESC
LIMIT 15;

-- Query 09: Filtering groups with HAVING
-- First restricts the source to December tables, then counts rows by event name. HAVING keeps only event types with at least 50,000 events, including exactly 50,000. WHERE filters source rows before aggregation; HAVING filters groups after aggregation.
SELECT event_name, COUNT(*) AS events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201201' AND '20201231'
GROUP BY event_name
HAVING COUNT(*) >= 50000
ORDER BY events DESC;

-- Query 10: Querying a week with wildcard tables
-- Uses events_* to match daily tables and _TABLE_SUFFIX to select December 1–7, 2020, inclusive. It counts events for each date and sorts chronologically. The suffix is the portion of each table name after events_. A constant suffix range restricts the tables read.
SELECT event_date, COUNT(*) AS events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201201' AND '20201207'
GROUP BY event_date
ORDER BY event_date;
