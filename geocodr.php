<?php

require '../vendor/autoload.php';

use \Slim;
use \PDO;

$config = require '../config.php';

$query = "
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
    ";

$app = new Slim\Slim();

$app->post('/', function() use ($app, $config, $query) {
    $db = new PDO($config);
    $stmt = $db->prepare($query);

    $address = $app->request()->params('address');
    $stmt->execute([':address' => $address]);
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $app->response->setStatus(200);
    echo json_encode($results);
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
