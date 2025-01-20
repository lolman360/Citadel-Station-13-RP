SUBSYSTEM_DEF(media_tracks)
	name = "Media Tracks"
	subsystem_flags = SS_NO_FIRE
	init_order = INIT_ORDER_MEDIA_TRACKS

	/// Every track, including secret
	var/list/all_tracks = list()
	/// Non-secret jukebox tracks
	var/list/jukebox_tracks = list()
	/// Lobby music tracks
	var/list/lobby_tracks = list()

/datum/controller/subsystem/media_tracks/Initialize(timeofday)
	load_tracks()
	sort_tracks()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/media_tracks/proc/load_tracks()
	var/jukebox_track_file = "config_static/jukebox.json"
	report_progress("Loading jukebox track: [jukebox_track_file]")

	if(!fexists(jukebox_track_file))
		error("File not found: [jukebox_track_file]")
		return

	var/list/jsonData = json_decode(file2text(jukebox_track_file))

	if(!istype(jsonData))
		error("Failed to read tracks from [jukebox_track_file], json_decode failed.")
		return

	for(var/entry in jsonData)

		// Critical problems that will prevent the track from working
		if(!istext(entry["url"]))
			error("Jukebox entry in [jukebox_track_file]: bad or missing 'url'. Tracks must have a URL.")
			continue
		if(!istext(entry["title"]))
			error("Jukebox entry in [jukebox_track_file]: bad or missing 'title'. Tracks must have a title.")
			continue
		if(!isnum(entry["duration"]))
			error("Jukebox entry in [jukebox_track_file]: bad or missing 'duration'. Tracks must have a duration (in deciseconds).")
			continue

		// Noncritical problems, we can keep going anyway, but warn so it can be fixed
		if(!istext(entry["artist"]))
			warning("Jukebox entry in [jukebox_track_file], [entry["title"]]: bad or missing 'artist'. Please consider crediting the artist.")
		if(!istext(entry["genre"]))
			warning("Jukebox entry in [jukebox_track_file], [entry["title"]]: bad or missing 'genre'. Please consider adding a genre.")

		var/datum/media_track/T = new(entry["url"], entry["title"], entry["duration"], entry["artist"], entry["genre"])

		T.secret = entry["secret"] ? 1 : 0
		T.lobby = entry["lobby"] ? 1 : 0

		all_tracks += T


/datum/controller/subsystem/media_tracks/proc/sort_tracks()
	report_progress("Sorting media tracks...")
	tim_sort(all_tracks, GLOBAL_PROC_REF(cmp_media_track_asc))

	jukebox_tracks.Cut()
	lobby_tracks.Cut()

	for(var/datum/media_track/T in all_tracks)
		if(!T.secret)
			jukebox_tracks += T
		if(T.lobby)
			lobby_tracks += T

//TODO: Needs to work with our bo bo admin system
/*
/datum/controller/subsystem/media_tracks/proc/manual_track_add()
	var/client/C = usr.client
	if(!check_rights(R_DEBUG|R_FUN))
		return

	// Required
	var/url = tgui_input_text(C, "REQUIRED: Provide URL for track, or paste JSON if you know what you're doing. See code comments.", "Track URL", multiline = TRUE)
	if(!url)
		return

	var/list/json
	try
		json = json_decode(url)
	catch

	/**
	 * Alternatively to using a series of inputs, you can use json and paste it in.
	 * The json base element needs to be an array, even if it's only one song, so wrap it in []
	 * The songs are json object literals inside the base array and use these keys:
	 * "url": the url for the song (REQUIRED) (text)
	 * "title": the title of the song (REQUIRED) (text)
	 * "duration": duration of song in 1/10ths of a second (seconds * 10) (REQUIRED) (number)
	 * "artist": artist of the song (text)
	 * "genre": artist of the song, REALLY try to match an existing one (text)
	 * "secret": only on hacked jukeboxes (true/false)
	 * "lobby": plays in the lobby (true/false)
	 */

	if(islist(json))
		for(var/song in json)
			if(!islist(song))
				to_chat(C, "<span class='warning'>Song appears to be malformed.</span>")
				continue
			var/list/songdata = song
			if(!songdata["url"] || !songdata["title"] || !songdata["duration"])
				to_chat(C, "<span class='warning'>URL, Title, or Duration was missing from a song. Skipping.</span>")
				continue
			var/datum/media_track/T = new(songdata["url"], songdata["title"], songdata["duration"], songdata["artist"], songdata["genre"], songdata["secret"], songdata["lobby"])
			all_tracks += T

			report_progress("New media track added by [C]: [T.title]")
		sort_tracks()
		return

	var/title = tgui_input_text(C, "REQUIRED: Provide title for track", "Track Title")
	if(!title)
		return

	var/duration = tgui_input_number(C, "REQUIRED: Provide duration for track (in deciseconds, aka seconds*10)", "Track Duration")
	if(!duration)
		return

	// Optional
	var/artist = tgui_input_text(C, "Optional: Provide artist for track", "Track Artist")
	if(isnull(artist)) // Cancel rather than empty string
		return

	var/genre = tgui_input_text(C, "Optional: Provide genre for track (try to match an existing one)", "Track Genre")
	if(isnull(genre)) // Cancel rather than empty string
		return

	var/secret = tgui_alert(C, "Optional: Mark track as secret?", "Track Secret", list("Yes", "Cancel", "No"))
	if(secret == "Cancel")
		return
	else if(secret == "Yes")
		secret = TRUE
	else
		secret = FALSE

	var/lobby = tgui_alert(C, "Optional: Mark track as lobby music?", "Track Lobby", list("Yes", "Cancel", "No"))
	if(lobby == "Cancel")
		return
	else if(secret == "Yes")
		secret = TRUE
	else
		secret = FALSE

	var/datum/media_track/T = new(url, title, duration, artist, genre)

	T.secret = secret
	T.lobby = lobby

	all_tracks += T

	report_progress("New media track added by [C]: [title]")
	sort_tracks()

/datum/controller/subsystem/media_tracks/proc/manual_track_remove()
	var/client/C = usr.client
	if(!check_rights(R_DEBUG|R_FUN))
		return

	var/track = tgui_input_text(C, "Input track title or URL to remove (must be exact)", "Remove Track")
	if(!track)
		return

	for(var/datum/media_track/T in all_tracks)
		if(T.title == track || T.url == track)
			all_tracks -= T
			qdel(T)
			report_progress("Media track removed by [C]: [track]")
			sort_tracks()
			return

	to_chat(C, "<span class='warning>Couldn't find a track matching the specified parameters.</span>")

/datum/controller/subsystem/media_tracks/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---")
	VV_DROPDOWN_OPTION("add_track", "Add New Track")
	VV_DROPDOWN_OPTION("remove_track", "Remove Track")


/datum/controller/subsystem/media_tracks/vv_do_topic(list/href_list)
	. = ..()
	IF_VV_OPTION("add_track")
		manual_track_add()
		href_list["datumrefresh"] = "\ref[src]"
	IF_VV_OPTION("remove_track")
		manual_track_remove()
		href_list["datumrefresh"] = "\ref[src]"
*/
