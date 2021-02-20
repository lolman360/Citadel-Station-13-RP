
///////////////////////////////////////////
//Power supplies
////////////////////////////////////////////
/obj/item/modularlaser/capacitor
	name = "modular laser part"
	desc = "I shouldn't exist."
	var/costmod = 1.0
	var/firedelay = 6 //im 99% sure these are in deciseconds

/obj/item/modularlaser/capacitor/basic
	name = "weapon power handler"
	desc = "A garden-variety power handling unit for a modular energy weapon."

/obj/item/modularlaser/capacitor/simple
	name = "simple weapon power handler"
	desc = "A simplistic power handling unit for a modular energy weapon."
	firedelay = 10

/obj/item/modularlaser/capacitor/simple/integral //meant to be unremoveable
	name = "integrated compact weapon power handler"
	desc = "A compact energy weapon power handling system. Unable to be removed from the weapon it is mounted in, normally."
	removable = FALSE

/obj/item/modularlaser/capacitor/eco
	name = "efficient weapon power handler"
	desc = "An energy handler for a modular energy weapon that recoups 15%  of the energy used, at the cost of a 50% longer delay between shots."
	costmod = 0.85
	firedelay = 8 //50% longer for a 20% cost discount

/obj/item/modularlaser/capacitor/eco/super
	name = "advanced energy-recovery weapon power handler"
	desc = "A power handler for a modular energy weapon that recoups 40% of the energy used, at the cost of doubled delay between shots."
	costmod = 0.6
	firedelay = 12 //100% longer for a 50% discount

/obj/item/modularlaser/capacitor/eco/hyper
	name = "bleeding-edge energy-recovery weapon power handler"
	desc = "A power handler for a modular energy weapon that recoups 75% of the energy used, at the cost of a 150% longer delay between shots."
	costmod = 0.25
	firedelay = 15//150% longer for 75% discount

/obj/item/modularlaser/capacitor/eco/admin //admin only.
	name = "zero-point energy-recovery weapon power handler"
	desc = "A power handler for a modular energy weapon that recoups almost all of the energy used."
	costmod = 0.01

/obj/item/modularlaser/capacitor/speed
	name = "throughput-calibrated weapon power handler"
	desc = "A power handler for a modular energy weapon that is 90% efficient, but has 33% less delay between shots."
	costmod = 1.1
	firedelay = 4

/obj/item/modularlaser/capacitor/speed/advanced
	name = "throughput-focused weapon power handler"
	desc = "A power handler for a modular energy weapon that is 75% efficient, but has 85% less delay between shots."
	costmod = 1.25
	firedelay = 1

/obj/item/modularlaser/capacitor/speed/admin
	name = "superconductive weapon power handler"
	desc = "A power handler for a modular energy weapon that is 100% efficient, and has no delay between shots."
	costmod = 1
	firedelay = 0

/obj/item/modularlaser/capacitor/cannon
	firedelay = 3
	removable = FALSE
