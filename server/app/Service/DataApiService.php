<?php

namespace App\Service;

use App\Http\Requests\KakaoRequest;
use App\Http\Requests\StationRequest;
use Carbon\Carbon;
use GuzzleHttp\Client;

class DataApiService
{
    private $key;
    private $client;
    private $page;

    const BASE_URL = 'http://openapi.airkorea.or.kr/openapi/services/rest/';
    const PARAM = '&dataTerm=DAILY&_returnType=json&pageNo=';
    const DUST_URL = 'ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty?ver=1.3';
    const STATION_URL = 'MsrstnInfoInqireSvc/getTMStdrCrdnt?ver=1.3';
    const NEARY_URL = 'MsrstnInfoInqireSvc/getNearbyMsrstnList?';
    const KAKAO_API = 'https://dapi.kakao.com/v2/local/geo/transcoord.json';

    public function __construct(Client $client)
    {
        $this->key = config('Api.key');
        $this->client = $client;
        $this->page = (int)request()->input('page', 1);
    }

    private function basicMakeUrl($typeUrl, $rows, $lastParam): String
    {
        $url = self::BASE_URL;
        $url .= $typeUrl;
        $url .= '&serviceKey='.$this->key;
        $url .= '&numOfRows='.$rows;
        $url .= self::PARAM.$this->page;
        foreach ($lastParam as $paramName => $value) {
            $url .= "&${paramName}=${value}";
        }

        return $url;
    }

    private function getNearStation($tmX, $tmY): String
    {
        return $this->basicMakeUrl(self::NEARY_URL, 25, ['tmX' => $tmX, 'tmY' => $tmY]);
    }

    /**
     * 측정소 이름으로 해당 지역 미세먼지 농도 알기.
     *
     * @param $stationName : 측정소 이름
     *
     * @return string : API URL
     */
    private function getDustUrl($stationName): String
    {
        return $this->basicMakeUrl(self::DUST_URL, 24, ['stationName' => $stationName]);
    }

    /**
     * 도시 이름으로 근처 측정소 정보 가져오기.
     *
     * @param $cityName  : 도시 이름
     *
     * @return string : API URL
     */
    private function getStationUrl($cityName): String
    {
        return $this->basicMakeUrl(self::STATION_URL, 10, ['umdName' => $cityName]);
    }

    /**
     * 도시 이름으로 지역 관측소 리스트 가져오기.
     *
     * @param StationRequest $request : city : 도시 이름
     *
     * @return \Illuminate\Http\JsonResponse
     *
     * @throws \GuzzleHttp\Exception\GuzzleException
     */
    public function getStation(StationRequest $request)
    {
        $url = $this->getStationUrl($request->city());
        $data = [];
        $totalPage = 0;

        try {
            $res = $this->client->request('GET', $url);
            $jsonData = \GuzzleHttp\json_decode($res->getBody(), 1);
            $totalPage = (int) $jsonData['totalCount'];
            $data = collect($jsonData['list'])->map(function ($json) {
                return [
                    'id' => (int) ((string) (int) $json['tmX'].(string) (int) $json['tmY']),
                    'tmX' => $json['tmX'],
                    'tmY' => $json['tmY'],
                    'sidoName' => $json['sidoName'],
                    'sggName' => $json['sggName'],
                    'umdName' => $json['umdName'],
                ];
            });
        } catch (\Exception $e) {
        }

        return response()->json([
            'row' => 10,
            'page' => (int)$request->input('page', 1),
            'totalPage' => ceil((int) $totalPage / 10),
            'list' => $data,
        ], 200, []);
    }

    public function convertTM(KakaoRequest $request)
    {
        $res = $this->client->request('get', self::KAKAO_API, [
            'query' => $request->getQuery(),
            'headers' => $request->getHeader(),
        ]);

        $jsonData = json_decode($res->getBody(), 1);

        return $jsonData['meta']['total_count'] > 0 ? [
            'tmX' => $jsonData['documents'][0]['x'],
            'tmY' => $jsonData['documents'][0]['y'],
        ] : [];
    }



    public function getDustData($stationName)
    {
        $url = $this->getDustUrl($stationName);
        $data = [];
        $totalPage = 0;

        try {
            $res = $this->client->request('GET', $url);
            $jsonData = \GuzzleHttp\json_decode($res->getBody(), 1);
            $totalPage = (int) $jsonData['totalCount'];

            $data = collect($jsonData['list'])->map(function ($json) use ($stationName) {
                return [
                    'station' => urldecode($stationName),
                    'coGrade' => (int)$json['coGrade'],
                    'dataTime' => Carbon::make($json['dataTime'])->diffForHumans(),
                    'pm10Grade' => (int)$json['pm10Grade1h'] ?? $json['pm10Grade'],
                    'pm25Grade' => (int)$json['pm25Grade1h'] ?? $json['pm25Grade'],
                ];
            });
        } catch (\Exception $e) {
        }

        return $data;
//        return response()->json([
//            'row' => 24,
//            'page' => request()->input('page', 1),
//            'totalPage' => ceil((int) $totalPage / 24),
//            'list' => $data,
//        ], 200, []);
    }

    public function getNearbyStation($tmData)
    {
        $url = $this->getNearStation($tmData['tmX'], $tmData['tmY']);
        $data = [];

        try {
            $res = $this->client->request('GET', $url);
            $jsonData = \GuzzleHttp\json_decode($res->getBody(), 1);

            $data = collect($jsonData['list'])->map(function ($json) {
                return [
                    'stationName' => $json['stationName'],
                    'tm' => $json['tm'],
                    'addr' => $json['addr'],
                ];
            });
        } catch (\Exception $e) {
        }

        return $data;
    }
}
