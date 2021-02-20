

///////////////////////////////////////////////////////
//Cooling
///////////////////////////////////////////////////////
/obj/item/modularlaser/cooling
	name = "modular laser part"
	desc = "I shouldn't exist."
	var/heatremovemod = 1.0
	var/costadd = 0
	var/heatcapmult = 1


/obj/item/modularlaser/cooling/basic
	name = "basic modular cooling system"
	desc = "A basic air-cooling system for a modular energy weapon."

/obj/item/modularlaser/cooling/lame
	name = "compact modular cooling system"
	desc = "A tiny air-cooling system for a modular energy weapon."


/obj/item/modularlaser/cooling/lame/integral
	removable = FALSE

/obj/item/modularlaser/cooling/efficient
	name = "heat recovery cooling system"
	desc = "A cooling system that uses heat from firing to recoup 10W power, but dissipates heat 10% slower."
	heatremovemod = 0.9
	costadd = -10

/obj/item/modularlaser/cooling/efficient/super
	name = "advanced heat recovery cooling system"
	desc = "A cooling system that uses heat from firing to generate 20W power. Dissipates heat 20% slower."
	heatremovemod = 0.8
	costadd = -20

/obj/item/modularlaser/cooling/speed
	name = "active cooling system"
	desc = "A cooling system that uses 10W more power to dissipate heat twice as fast."
	heatremovemod = 2
	costadd = 10

/obj/item/modularlaser/cooling/speed/adv
	name = "superradiative cooling system"
	desc = "A cooling system that forces heat from firing into the air around it extremely quickly, quadrupling the heat dissipation. Uses 20W power."
	heatremovemod = 4
	costadd = 20

//todo: add these to lathe
/obj/item/modularlaser/cooling/heatcap
	name = "heat storage cooling system"
	desc = "A cooling system that can store more heat, but has 5% less dissipation."
	heatcapmult = 1.5
	heatremovemod = 0.95

/obj/item/modularlaser/cooling/heatcap/adv
	name = "heat battery cooling system"
	desc = "A cooling system that can store more heat, but has 10% less dissipation."
	heatcapmult = 2.5
	heatremovemod = 0.9
