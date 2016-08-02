local weather_file=${ZSH_CACHE_DIR}/weather

# Fetch weather in background and print if finished
function async_weather_from_geo() {
	local city=$(LocateMe -f "{LAT},{LON}")
	local weather=$(curl -s wttr.in/$city | awk 'FNR>=2 && FNR<=7')
	echo "$weather" > $weather_file
	tput sc
	tput cup 1 0
	echo "$weather"
	tput rc
}

# Initiate new weather fetching
# Also test if internet is available
function new_weather() {
	# Test connection to 8.8.8.8 with 2 second timeout
	nc -z 8.8.8.8 53 -G 2  >/dev/null 2>&1
	if [[ $? -ne 0 ]]; then
		# Fallback to cached weather with no internet connection
		if [[ -f $weather_file ]] && [[ -s $weather_file ]]; then
			# echo "Forecast for $(date -r $modified)"
			tput sc
			tput cup 1 0
			cat $weather_file
			tput rc
		else
			tput sc
			tput cup 1 0
			echo "Can't show any weather right now. Sorry."
			tput rc
		fi
	else
		# Async call weather
		echo "\n\n\n       Fetching weather..."
		echo "\n"
		(async_weather_from_geo &)
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
		# echo "Forecast for $(date -r $modified)"
		cat $weather_file
	else
		new_weather
	fi
else
	new_weather
fi

alias delete-weather-cache="rm $weather_file"
