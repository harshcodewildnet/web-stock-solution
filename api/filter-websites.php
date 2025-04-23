<?php
header('Content-Type: application/json');
require_once '../includes/db.php'; // DB connection

// Get incoming JSON and decode
$input = json_decode(file_get_contents('php://input'), true);

// Initialize where conditions array
$conditions = [];

// Helper to map filters into SQL-safe conditions
function buildInCondition($column, $values, $conn) {
    // Escape each value to prevent SQL injection
    $escaped = array_map(function($val) use ($conn) {
        return "'" . $conn->real_escape_string($val) . "'";
    }, $values);

    // Join values as comma-separated for SQL IN clause
    return "$column IN (" . implode(",", $escaped) . ")";
}

// Category
if (!empty($input['category'])) {
    $conditions[] = buildInCondition("category", $input['category'], $conn);
}

// Traffic (e.g., "0-1000" => traffic BETWEEN 0 AND 1000)
if (!empty($input['traffic'])) {
    $trafficParts = [];
    foreach ($input['traffic'] as $range) {
        [$min, $max] = explode("-", str_replace("K", "000", $range));
        $trafficParts[] = "(traffic BETWEEN $min AND $max)";
    }
    $conditions[] = "(" . implode(" OR ", $trafficParts) . ")";
}

// Location
if (!empty($input['location'])) {
    $conditions[] = buildInCondition("location", $input['location'], $conn);
}

// DA Range
if (!empty($input['da'])) {
    $daParts = [];
    foreach ($input['da'] as $range) {
        [$min, $max] = explode("-", $range);
        $daParts[] = "(da BETWEEN $min AND $max)";
    }
    $conditions[] = "(" . implode(" OR ", $daParts) . ")";
}

// DR Range
if (!empty($input['dr'])) {
    $drParts = [];
    foreach ($input['dr'] as $range) {
        [$min, $max] = explode("-", $range);
        $drParts[] = "(dr BETWEEN $min AND $max)";
    }
    $conditions[] = "(" . implode(" OR ", $drParts) . ")";
}

// Price Range
if (!empty($input['price'])) {
    $priceParts = [];
    foreach ($input['price'] as $range) {
        [$min, $max] = explode("-", str_replace("$", "", $range));
        $priceParts[] = "(price BETWEEN $min AND $max)";
    }
    $conditions[] = "(" . implode(" OR ", $priceParts) . ")";
}

// Spam Score
// if (!empty($input['spam'])) {
//     $spamParts = [];
//     foreach ($input['spam'] as $range) {
//         preg_match('/(\d+)%.*?(\d+)%/', $range, $matches);
//         if (count($matches) === 3) {
//             $spamParts[] = "(spam_score BETWEEN {$matches[1]} AND {$matches[2]})";
//         }
//     }
//     if (!empty($spamParts)) {
//         $conditions[] = "(" . implode(" OR ", $spamParts) . ")";
//     }
// }


// Spam Score
if (!empty($input['spam'])) {
    $spamParts = [];

    // Loop through each range (e.g., "0-10", "11-30")
    foreach ($input['spam'] as $range) {
        // Split the string into min and max values
        [$min, $max] = explode('-', $range);

        // Make sure both values are numeric before using in SQL
        if (is_numeric($min) && is_numeric($max)) {
            $spamParts[] = "(spam_score BETWEEN $min AND $max)";
        }
    }

    // Add combined condition to the final list
    if (!empty($spamParts)) {
        $conditions[] = '(' . implode(' OR ', $spamParts) . ')';
    }
}


// Status
if (!empty($input['status'])) {
    $conditions[] = buildInCondition("status", $input['status'], $conn);
}

// Added By
if (!empty($input['addedby'])) {
    $conditions[] = buildInCondition("added_by", $input['addedby'], $conn);
}

// Timeline filter (using created/added date)
if (!empty($input['timeline'])) {
    $timelineParts = [];
    foreach ($input['timeline'] as $range) {
        switch ($range) {
            case "Today":
                $timelineParts[] = "DATE(date_added) = CURDATE()";
                break;
            case "Last 7 Days":
                $timelineParts[] = "date_added >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)";
                break;
            case "Last 30 Days":
                $timelineParts[] = "date_added >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)";
                break;
            case "This Year":
                $timelineParts[] = "YEAR(date_added) = YEAR(CURDATE())";
                break;
        }
    }
    if (!empty($timelineParts)) {
        $conditions[] = "(" . implode(" OR ", $timelineParts) . ")";
    }
}

// Build final query
$sql = "SELECT * FROM websites";
if (!empty($conditions)) {
    $sql .= " WHERE " . implode(" AND ", $conditions);
}

// Execute the query
$result = $conn->query($sql);
$websites = [];

// Collect results
if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $websites[] = [
            'category'       => $row['category'],
            'url'            => $row['url'],
            'currency'       => $row['currency'],
            'price'          => $row['price'],
            'client_name'    => $row['client_name'],
            'blogger_name'   => $row['blogger_name'],
            'blogger_email'  => $row['blogger_email'],
            'blogger_mobile' => $row['blogger_mobile'],
            'spam_score'     => $row['spam_score'],
            'dr'             => $row['dr'],
            'da'             => $row['da'],
            'traffic'        => $row['traffic'],
            'location'       => $row['location'],
            'mode'           => $row['mode'],
            'added_by'       => $row['added_by'],
            'status'         => $row['status'],
            'date_added'     => $row['date_added']
        ];
        
    }
}

// Return as JSON
echo json_encode([
    'status' => 'success',
    'count' => count($websites),
    'websites' => $websites
]);
