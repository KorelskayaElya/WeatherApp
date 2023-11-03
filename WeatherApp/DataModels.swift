//
//  DataModels.swift
//  WeatherApp
//
//  Created by Эля Корельская on 30.10.2023.
//
/*

"current": {
 //current.dt Текущее время, Unix, UTC
"dt": 1698689803,
 //current.sunriseВремя восхода солнца, Unix, UTC. Для полярных областей в полуночном солнце и полярных ночных периодах этот параметр не возвращается в ответе
"sunrise": 1698640213,
 //current.sunsetВремя заката, Unix, UTC. Для полярных областей в полуночном солнце и полярных ночных периодах этот параметр не возвращается в ответе
"sunset": 1698674165,
 // current.tempТемпература. Единицы - по умолчанию: Кельвин, метрика: Цельсия, имперский: Фаренгейт. Как изменить используемые единицы измерения
"temp": 277.8,
 // current.feels_likeТемпература. Этот температурный параметр учитывает человеческое восприятие погоды. Единицы измерения - по умолчанию: Кельвин, метрика: Цельсия, имперский: Фаренгейт.
"feels_like": 274.44,
 //current.pressureАтмосферное давление на уровне моря, гПа
"pressure": 1006,
 //current.humidityВлажность, %
"humidity": 100,
 //current.dew_pointТемпература атмосферы (измерение в зависимости от давления и влажности), ниже которой капли воды начинают конденсироваться и может образовываться роса. Единицы измерения - по умолчанию: кельвин, метрика: по Цельсию, имперский: по Фаренгейту
"dew_point": 277.8,
//current.uviТекущий УФ-индекс.
"uvi": 0,
 //current.cloudsОблачность, %
"clouds": 100,
 // current.wind_speedСкорость ветра. Скорость ветра. Единицы измерения - по умолчанию: метр/сек, метрика: метр/сек, имперский: мили/час. Как изменить используемые единицы измерения
"wind_speed": 4.24,
 // current.wind_degНаправление ветра, градусы (метеорологические)
"wind_deg": 234,
 // current.wind_gust (где доступно) Порыв ветра. Единицы измерения - по умолчанию: метр/сек, метрика: метр/сек, имперский: мили/час. Как изменить используемые единицы измерения
"wind_gust": 12.31,
"weather": [
{
 // current.weather.id Ид погодных условий
"id": 804,
 // current.weather.mainГруппа погодных параметров (дождь, снег и т. д.)
"main": "Clouds",
 // current.weather.descriptionПогодные условия в группе (полный список погодных условий). Получите выходные данные на вашем языке
"description": "пасмурно",
 //current.weather.iconИконка погоды.
"icon": "04n"
}
]
}
 */
import Foundation


struct WeatherData: Codable {
    var lat: Double = 0.0
    var lon: Double = 0.0
    var timezone: String = ""
    var timezone_offset: Int = 0
    var current: CurrentWeather = CurrentWeather()
}

struct CurrentWeather: Codable {
    var dt: Int = 0
    var sunrise: Int = 0
    var sunset: Int = 0
    var temp: Double = 0.0
    var feels_like: Double = 0.0
    var pressure: Int = 0
    var humidity: Int = 0
    var dew_point: Double = 0.0
    var uvi: Double = 0.0
    var clouds: Int = 0
    var wind_speed: Double = 0.0
    var wind_deg: Int = 0
    var wind_gust: Double = 0.0
    var weather: [WeatherDescription] = []
}

struct WeatherDescription: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}
