import Foundation
import Combine

/// Manages weather data and weather-based suggestions
class WeatherManager: ObservableObject {
    static let shared = WeatherManager()
    
    @Published var currentWeather: WeatherData?
    @Published var weatherSuggestion: String?
    
    private let apiKey = "YOUR_API_KEY" // Replace with actual API key
    private var cancellables = Set<AnyCancellable>()
    
    private init() {}
    
    // MARK: - Fetch Weather
    
    func fetchWeather(latitude: Double, longitude: Double) {
        // Using OpenWeatherMap API (free tier)
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Weather fetch error: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                self?.processWeatherData(response)
            }
            .store(in: &cancellables)
    }
    
    private func processWeatherData(_ response: WeatherResponse) {
        let weather = WeatherData(
            temperature: response.main.temp,
            feelsLike: response.main.feelsLike,
            humidity: response.main.humidity,
            condition: response.weather.first?.main ?? "Unknown",
            description: response.weather.first?.description ?? ""
        )
        
        currentWeather = weather
        generateWeatherSuggestion(weather)
    }
    
    // MARK: - Weather-Based Suggestions
    
    private func generateWeatherSuggestion(_ weather: WeatherData) {
        var suggestion = ""
        
        // Temperature-based suggestions
        if weather.temperature > 30 {
            suggestion = "🌡️ It's very hot today (\(Int(weather.temperature))°C)! Don't forget to drink plenty of water while fasting. Prefer light exercises."
        } else if weather.temperature > 25 {
            suggestion = "☀️ It's hot (\(Int(weather.temperature))°C). Stay in cool places and increase your water goals for hydration."
        } else if weather.temperature < 10 {
            suggestion = "🥶 Hava soğuk (\(Int(weather.temperature))°C). Sıcak tutun ve sıcak bitki çayları içebilirsiniz."
        }
        
        // Humidity-based suggestions
        if weather.humidity > 80 {
            if suggestion.isEmpty {
                suggestion = "💧 Nem oranı yüksek (%\(weather.humidity)). Daha fazla su tüketmeye dikkat edin."
            }
        }
        
        // Weather condition-based suggestions
        if weather.condition == "Rain" {
            suggestion = "🌧️ Yağmurlu hava. İç mekan aktiviteleri planlayın ve hidrasyonunuzu koruyun."
        } else if weather.condition == "Snow" {
            suggestion = "❄️ Kar yağışı var. Sıcak kalın ve enerji rezervlerinize dikkat edin."
        } else if weather.condition == "Clear" && weather.temperature > 28 {
            suggestion = "🌞 Güneşli ve sıcak! Gölgede kalın, güneş kremi sürün ve bol su için."
        }
        
        weatherSuggestion = suggestion.isEmpty ? nil : suggestion
        
        // Send notification if weather is extreme
        if !suggestion.isEmpty {
            sendWeatherNotification(suggestion)
        }
    }
    
    private func sendWeatherNotification(_ message: String) {
        NotificationManager.shared.scheduleWeatherAlert(message: message)
    }
    
    // MARK: - Auto Update
    
    func startAutoUpdates(latitude: Double, longitude: Double) {
        // Update weather every 30 minutes
        Timer.scheduledTimer(withTimeInterval: 1800, repeats: true) { [weak self] _ in
            self?.fetchWeather(latitude: latitude, longitude: longitude)
        }
        
        // Initial fetch
        fetchWeather(latitude: latitude, longitude: longitude)
    }
}

// MARK: - Models

struct WeatherData {
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let condition: String
    let description: String
}

struct WeatherResponse: Codable {
    let main: MainWeather
    let weather: [Weather]
}

struct MainWeather: Codable {
    let temp: Double
    let feelsLike: Double
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case humidity
    }
}

struct Weather: Codable {
    let main: String
    let description: String
}
