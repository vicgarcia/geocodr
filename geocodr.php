<?php

require '../vendor/autoload.php';

use \Slim;
use \PDO;

$tokens = require '../tokens.php';

$sql = preg_replace('/\s+/', ' ', "
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

$app->post('/', function() use ($app, $tokens, $sql) {
    $address = $app->request()->params('address');
    $token = $app->request()->params('token');

    if (in_array($token, $tokens)) {
        $db = new PDO(
            'pgsql:dbname=geocodr;host=localhost;user=geocodr;password=geocodr'
        );
        $stmt = $db->prepare($sql);
        $stmt->execute([':address' => $address]);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        //var_dump($rows);

        $app->response->setStatus(200);
        echo json_encode($rows);
    } else {
        $app->response->setStatus(403);
        echo 'invalid token';
    }
});

$app->notFound(function () use ($app) {
    $app->response->setStatus(404);
    echo 'nothing there';
});

$app->error(function (\Exception $e) use ($app) {
    $app->response->setStatus(500);
    echo 'something broke';
});

$app->run();
