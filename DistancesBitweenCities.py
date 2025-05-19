import sys
from geopy.geocoders import Nominatim # For converting addresses to coordinates
from geopy.distance import geodesic # For calculating distances between coordinates
# we use OpenStreetMap to get geopy 

def get_coordinates(city):
    try:
        # Initialize geocoder with a unique user agent and timeout
        # we use timeout to prevent  the slow connection 
        nom = Nominatim(user_agent="city_lat_long", timeout=10) 
        location = nom.geocode(city + ", Saudi Arabia")  
        if location:
            return location.latitude, location.longitude
        else:
            return None
            
    except Exception as e:
        print("Error processing: ", city, "| The issue", e, file=sys.stderr)
        return None

if __name__ == "__main__":

    if len(sys.argv) == 3:
        city1, city2 = sys.argv[1], sys.argv[2] #city names and sys.argv[0] is the script name
        coords1 = get_coordinates(city1)
        coords2 = get_coordinates(city2)
        
        if coords1 and coords2:
            distance = round(geodesic(coords1, coords2).km, 2)# round the distance.km to 2 decimal 
            print(f"{distance}")
        else:
             # if incorrect number of arguments
            print("not found")
    else:
        print("(use this format to run the script): python DistancesBitweenCities.py <city1> <city2>")

