<?php

namespace App\Http\Controllers;

use App\Http\Requests\DustRequest;
use App\Http\Requests\KakaoRequest;
use App\Http\Requests\StationRequest;
use App\Service\DataApiService;
use GuzzleHttp\Client;

class ApiController extends Controller
{
    private $client;
    private $service;

    public function __construct(Client $client, DataApiService $service)
    {
        $this->client = $client;
        $this->service = $service;
    }

//    public function station(StationRequest $request)
//    {
//        return $this->service->getStation($request);
//    }

    public function dust(DustRequest $request)
    {
        $dustData = $this->service->getDustData($request->station());
        return $dustData[0];
    }

    public function tm(KakaoRequest $request)
    {
        $tmData = $this->service->convertTM($request);
        return $this->service->getNearbyStation($tmData);
    }
}
