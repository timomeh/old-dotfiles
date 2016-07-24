local weather_file=${ZSH_CACHE_DIR}/weather

# Geocode current location
function geo_place() {
	local geocode="$(whereami | tr '\n' ' ')";
	local arr=("${(@s/ /)geocode}")
	local lat=${arr[2]};
	local long=${arr[4]};
	local json="$(curl -s "http://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${long}&zoom=18&addressdetails=1&accept-language=en_US")"
	local city="$(echo $json | jq .address.village | sed -e 's/^"//'  -e 's/"$//' | iconv -c -f utf-8 -t us-ascii//TRANSLIT | tr -d "\"\`^'")"
	local country="$(echo $json | jq .address.country | sed -e 's/^"//'  -e 's/"$//' | iconv -c -f utf-8 -t us-ascii//TRANSLIT | tr -d "\"\`^'")"
	echo "$city,$country"
}

# Fetch weather in background and print if finished
function async_weather() {
	local city=$(geo_place)
	local weather=$(curl -s wttr.in/$city | awk 'FNR>=0 && FNR<=7')
	echo "$weather" > $weather_file
	tput sc
	tput cup 1 0
	tput el
	echo "New Forcast for $(date)"
	tput cup 2 0
	echo "$weather"
	tput rc
}

# Initiate new weather fetching
# Also test if internet is available
function new_weather() {
	# Test connection to 8.8.8.8
	nc -z 8.8.8.8 53  >/dev/null 2>&1
	if [[ $? -ne 0 ]]; then
		# Fallback to cached weather with no internet connection
		if [[ -f $weather_file ]] && [[ -s $weather_file ]]; then
			echo "Forecast for $(date -r $modified)"
			cat $weather_file
		else
			echo "Can't show any weather right now. Sorry."
		fi
	else
		# Async call weather
		echo "Fetching weather..."
		echo "\n\n\n\n\n\n"
		(async_weather $city &)
	fi
}

# Check if cached file exists,
# then compare last-modified with current date
# and get new weather, if file is older than 60 minutes.
# If weather is in cache, read it from cache!
if [[ -f $weather_file ]] && [[ -s $weather_file ]]; then
	local modified=$(stat -f '%Sm' -t '%s' $weather_file)
	local curr=$(date +'%s')
	let "plus = $modified + 3600"
	if [[ "$plus" -gt "$curr" ]]; then
		echo "Forecast for $(date -r $modified)"
		cat $weather_file
	else
		new_weather
	fi
else
	new_weather
fi

alias delete-weather-cache="rm $weather_file"
