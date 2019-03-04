(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

   (:action robotMove
      :parameters (?r - robot ?li - location ?lf - location)
      :precondition (and (at ?r ?li) (no-robot ?lf) (connected ?li ?lf))
      :effect (and (at ?r ?lf) (not (at ?r ?li)) (not (no-robot ?lf)) (no-robot ?li))
   )

   (:action robotMoveWithPalette
      :parameters (?r - robot ?li - location ?lf - location ?p - pallette)
      :precondition (and (at ?r ?li) (at ?p ?li) (no-robot ?lf) (no-pallette ?lf) (connected ?li ?lf))
      :effect (and (at ?r ?lf) (at ?p ?lf)
                   (not (at ?r ?li)) (not (no-robot ?lf))
                   (not (at ?p ?li)) (not (no-pallette ?lf))
                   (no-robot ?li) (no-pallette ?li)
                   (has ?r ?p))
   )

   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?p - pallette ?o - order ?s - shipment ?si - saleitem)
      :precondition (and (ships ?s ?o) (orders ?o ?si)
                    (not (includes ?s ?si)) (contains ?p ?si) 
                    (started ?s) (not (complete ?s))
                    (packing-location ?l) (packing-at ?s ?l) (at ?p ?l))
      :effect (and (not (contains ?p ?si)) (includes ?s ?si))
   ) 

   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (started ?s) (not (complete ?s)) (ships ?s ?o) (packing-location ?l) (packing-at ?s ?l))
      :effect (and (complete ?s) (available ?l))
   )

)