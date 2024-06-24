/// global datum that will preload variables on atoms instanciation
/// this is global for security and speed
GLOBAL_REAL(dmm_preloader, /datum/dmm_preloader) = new
/// this is global for security and speed; if active, atoms will invoke the preloader on New()
///
/// * any atom is allowed to arbitrarily set this to FALSE, but not TRUE, on New()
/// * this is so things like /turf/space/basic that intentionally don't invoke the preloader will still turn it off like atoms should after they preload
GLOBAL_REAL_VAR(dmm_preloader_active) = FALSE
/// target typepath
GLOBAL_REAL_VAR(dmm_preloader_target)

/// Preloader datum
/datum/dmm_preloader
	parent_type = /datum

	//* -- /parsed_map load cycle -- *//

	/// the current active orientation.
	///
	/// * the natural orientation is SOUTH.
	/// * specifying a non-SOUTH orientation rotates the map clockwise to match that orientation.
	var/loading_orientation
	/// the active maploader context
	var/datum/dmm_context/loading_context

	//* --      set per atom      -- *//
	var/list/attributes
	var/turn_angle
	var/swap_x
	var/swap_y
	var/swap_xy

// todo: OPTIMIZE THE SHIT OUT OF ALL OF THIS
// because citrp is so quirky and funny we now call this for every fucking atom
// this is not good
// this means that we really need to optimize this to not just be attributes.
// maybe we can get all the swap stuff compounded down? who knows lol
// fucked.

/world/proc/preloader_setup(list/the_attributes, path, turn_angle, swap_x, swap_y, swap_xy)
	global.dmm_preloader_active = TRUE
	global.dmm_preloader_target = path
	var/datum/dmm_preloader/preloader_local = global.dmm_preloader
	preloader_local.attributes = the_attributes
	if(turn_angle != 0)
		preloader_local.turn_angle = turn_angle
		preloader_local.swap_x = swap_x
		preloader_local.swap_y = swap_y
		preloader_local.swap_xy = swap_xy

/world/proc/preloader_load(atom/what)
	global.dmm_preloader_active = FALSE
	var/datum/dmm_preloader/preloader_local = global.dmm_preloader
	for(var/attribute in preloader_local.attributes)
		var/value = preloader_local.attributes[attribute]
		if(islist(value))
			value = deep_copy_list(value)
		#ifdef TESTING
		if(what.vars[attribute] == value)
			var/message = "<font color=green>[what.type]</font> at [AREACOORD(what)] - <b>VAR:</b> <font color=red>[attribute] = [isnull(value) ? "null" : (isnum(value) ? value : "\"[value]\"")]</font>"
			log_mapping("DIRTY VAR: [message]")
			GLOB.dirty_vars += message
		#endif
		what.vars[attribute] = value

	// handle post processing, so things like directions on subtypes don't break.
	// only do everything if necessary.
	if(preloader_local.turn_angle != 0 && what.preloading_dir(preloader_local))
		var/multi_tile = ismovable(what) && ((what:bound_width > WORLD_ICON_SIZE) || (what:bound_height > WORLD_ICON_SIZE)) && (what.appearance_flags & TILE_MOVER)
		var/dx
		var/dy
		if(multi_tile)
			// normal multi tile rotation can only handle things that are 'centered' on their bound width/height
			// if something needs to change that every rotation, it needs to override preloading_dir
			var/atom/movable/casted = what
			// deal with their bounds
			var/bx = casted.bound_x
			var/by = casted.bound_y
			if(preloader_local.swap_y)			//same order of operations as the load rotation, mirror and then x/y swapping.
				by = -by
			if(preloader_local.swap_x)
				bx = -bx
			if(preloader_local.swap_xy)
				var/obx = bx
				bx = by
				by = obx
				var/obw = casted.bound_width
				casted.bound_width = casted.bound_height
				casted.bound_height = obw
			casted.bound_x = bx
			casted.bound_y = by
			// not a pixel mover, we can assume it's multiples of world icon size
			dx = round((casted.bound_width / WORLD_ICON_SIZE) - (casted.bound_x / (WORLD_ICON_SIZE / 2)) - 1)
			dy = round((casted.bound_height / WORLD_ICON_SIZE) - (casted.bound_y / (WORLD_ICON_SIZE / 2)) - 1)
			casted.x -= dx * ((preloader_local.swap_x ^ preloader_local.swap_xy)? 1 : 0)
			casted.y -= dy * ((preloader_local.swap_y ^ preloader_local.swap_xy)? 1 : 0)

		what.dir = turn(what.dir, preloader_local.turn_angle)
		var/px = what.pixel_x
		var/py = what.pixel_y
		if(preloader_local.swap_y)			//same order of operations as the load rotation, mirror and then x/y swapping.
			py = -py
		if(preloader_local.swap_x)
			px = -px
		if(preloader_local.swap_xy)
			var/opx = px
			px = py
			py = opx
		what.pixel_x = px
		what.pixel_y = py

	what.preloading_instance(preloader_local.loading_context)

