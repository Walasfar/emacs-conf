(in-package #:albion-data-parser)

;;;; "Caerleon Bridgewatch FortSterling BlackMarket Lymhurst Martlock Thetford"

(defun write-ods (city path)
  (let ((text-props-title  '(:color "#f46321" :font-name "Liberation Mono" :font-size "18pt"))
	(text-props-header '(:color "#000000" :font-name "Liberation Mono" :font-size "14pt"))
	(text-props-normal '(:color "#000000" :font-name "Liberation Sans" :font-size "11pt")))
    (clods:with-spreadsheet (path :generator "write-ods" :creator "Albion Markets")
      (clods:using-fonts ()
	(clods:font "Liberation Sans" :family "Liberation Sans" :family-generic :swiss)
	(clods:font "Liberation Mono" :family "Liberation Mono" :family-generic :swiss))

      (clods:using-styles (:locale (clods:make-locale "FI" #\Space 3 #\,))

	(clods:number-text-style "n-text")

	(clods:cell-style "ce-normal" nil text-props-normal :horizontal-align :center :border '(:thin :solid "#000000"))
	(clods:cell-style "ce-header" "ce-normal" text-props-header )
	(clods:cell-style "ce-title" "ce-normal" text-props-title :horizontal-align :center :border '(:thin :solid "#000000"))

	(clods:column-style "co-default" nil :use-optimal-width t)

	(clods:row-style "ro-normal" nil :height "14pt" :use-optimal-height t)
	(clods:row-style "ro-title" nil :height "24pt" :use-optimal-height t))

      (clods:with-body ()
	(clods:with-table ("Resources")
	  (clods:with-header-columns ()
	    (clods:column :style "co-default" :style "ce-normal"))
	  (clods:column :style "co-default" :cell-style "ce-normal")

	  (clods:with-header-rows ()
	    (clods:with-row (:repeat 2))
	    (clods:with-row (:style "ro-title")
	      (clods:cell "Resources listing" :style "ce-title" :span-columns 5))
	    (clods:with-row (:style "ro-normal" :cell-style "ce-normal")
	      (clods:cells "Тир" "Кожа" "Ткань" "Брусья" "Слитки")))
	  
	  (let ((leathers (get-for-sheet "Leather" city)) ; "Leather" "Cloth" "Planks" "Metalbars"
		(cloths (get-for-sheet "Cloth" city))
		(planks (get-for-sheet "Planks" city))
		(metalbars (get-for-sheet "Metalbars" city)))
	    (loop for rank in *ranks*
		  for leather in leathers
		  for cloth in cloths
		  for plank in planks
		  for metalbar in metalbars
		  do (clods:with-row (:style "ro-normal" :cell-style "ce-normal")
		       (clods:cells (format nil "~A " rank) leather cloth plank metalbar))))


	  (clods:with-row (:repeat 2))
	  (clods:with-row (:style "ro-title")
	    (clods:cell "Artefacts listing" :style "ce-title" :span-columns 6))
	  (clods:with-row (:style "ro-normal" :cell-style "ce-normal")
	    (clods:cells "Предмет" "T4" "T5" "T6" "T7" "T8"))


	  (let ((artefact-items (list (list-prices-for-sheet (find-specific-item "cloth" "armor" "keeper"))
				      (list-prices-for-sheet (find-specific-item "cloth" "head" "keeper"))
				      (list-prices-for-sheet (find-specific-item "cloth" "shoes" "keeper"))))
		(artefact-name '("Druid Armor" "Druid Helm" "Druid Shoes")))
	    (loop for cloth-helm in artefact-name 
		  for (t4 t5 t6 t7 t8) in artefact-items
		  do (clods:with-row (:style "ro-normal" :cell-style "ce-normal")
		       (clods:cells cloth-helm t4 t5 t6 t7 t8)))))))))
