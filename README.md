In order for the app to run as expected, it requires a Config.xcconfig file that contains a WEATHER_API_KEY with a corresponding api key.
The app is not perfect, and the icons that are returned by the weather api are not the best quality, so they will seem a little bit 
pixelated.

The project should work for both iphone and ipad.

Steps to run

1. clone repo: git clone https://github.com/MystiqueEnterprisesDevelopment/Nooro_TakeHome.git
2. add a new Config.xcconfig file
3. add a WEATHER_API_KEY to the config file with the appropriate key. Email me if you need my specific key.
4. Ensure profiles are set correctly to run the app.
5. Build and run the app.


Notes:

- the asynccachableimage with the cache is included from a previous project. It is not the most efficient, but it works as expected.
- i was originally operating under the assumption that the search results would be related to autocomplete functionality, but the docs did 
not mention that, so I had to make some changes.
- traditionally I would add additional layers that separate domain/ui objects. In this project, for time reasons, I created a 
WeatherDetailsModel which is returned from the 
repository actor and passed into the corresponding view. normally I would have a specific view model for the view and a separate domain 
model.
