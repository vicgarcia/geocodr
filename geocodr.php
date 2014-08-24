<?php

require '../vendor/autoload.php';

use \Slim;
use \PDO;

$tokens = require '../tokens.php';
$connection = require '../connection.php';

$query = preg_replace('/\s+/', ' ', "
  SELECT
    g.rating,
    ST_X(g.geomout) As lon,
    ST_Y(g.geomout) As lat,
    (addy).address As stno,
    (addy).streetname As street,
    (addy).streettypeabbrev As styp,
    (addy).location As city,
    (addy).stateabbrev As st,
    (addy).zip
  FROM
    geocode(:address) AS g;
");

$app = new Slim\Slim();

$app->post('/', function() use ($app, $tokens, $connection, $query) {
    $token = $app->request()->params('token');
    if (in_array($token, $tokens)) {
        $db = new PDO($connection);
        $stmt = $db->prepare($query);
        $address = $app->request()->params('address');
        $stmt->execute([':address' => $address]);
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $app->response->setStatus(200);
        echo json_encode($results);
    } else {
        $app->response->setStatus(403);
        echo 'invalid token';
    }
});

$app->notFound(function () use ($app) {
    $app->response->setStatus(404);
    echo 'nothing here';
});

$app->error(function (\Exception $e) use ($app) {
    $app->response->setStatus(500);
    echo 'something broke';
});

$app->run();
