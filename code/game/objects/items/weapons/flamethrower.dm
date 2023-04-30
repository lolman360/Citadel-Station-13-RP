#define FUEL_PER_TILE_MIN 1
#define FUEL_PER_TILE_MAX 5


/obj/item/flamethrower
	name = "flamethrower"
	desc = "You are a firestarter!"
	icon = 'icons/obj/flamethrower.dmi'
	icon_state = "flamethrowerbase"
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_guns.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_guns.dmi',
			)
	item_state = "flamethrower_0"
	damage_force = 5
	throw_force = 10
	throw_speed = 1
	throw_range = 3
	w_class = ITEMSIZE_LARGE
	origin_tech = list(TECH_COMBAT = 1, TECH_PHORON = 1)
	matter = list(MAT_STEEL = 2000)
	var/obj/item/reagent_containers/tank //where we take reagents from
	var/throw_length = 6 //s.e
	var/throw_width = 0 //s.e
	var/jammed //s.e
	var/lit = 0	//on or off
	var/operating = 0//cooldown


/obj/item/reagent_containers/spray/chemsprayer/Spray_at(atom/A as mob|obj)
	var/direction = get_dir(src, A)
	var/turf/T = get_turf(A)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/list/the_targets = list(T, T1, T2)

	for(var/a = 1 to 3)
		spawn(0)
			if(reagents.total_volume < 1) break
			var/obj/effect/water/chempuff/D = new/obj/effect/water/chempuff(get_turf(src))
			var/turf/my_target = the_targets[a]
			D.create_reagents(amount_per_transfer_from_this)
			if(!src)
				return
			playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1, -6)
			reagents.trans_to_obj(D, amount_per_transfer_from_this)
			D.set_color()
			D.set_up(my_target, rand(6, 8), 2)
	return
