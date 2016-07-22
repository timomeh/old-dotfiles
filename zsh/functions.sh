function nosleep() {
	let "seconds = $1 * 60"
	echo "Won't sleep for ${1} minutes"
	(caffeinate -u -t $seconds &)
}
export nosleep