;;;; write-in-sheet.lisp

(in-package #:albion-trader)


(defun write-ods (path)
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
	  
	  (let ((cloths    (res-prices "T2_CLOTH"))
		(leathers  (res-prices "T2_LEATHER"))
		(planks    (res-prices "T2_PLANKS"))
		(metalbars (res-prices "T2_METALBAR")))
	    (loop :for rank :in *ranks*
		  :for cloth    :in cloths
		  :for leather  :in leathers
		  :for plank    :in planks
		  :for metalbar :in metalbars
		  do (clods:with-row (:style "ro-normal" :cell-style "ce-normal")
		       (clods:cells (format nil "~A" rank) leather cloth plank metalbar))))
	  
	  (clods:with-row (:repeat 2))
	  (clods:with-row (:style "ro-title")
	    (clods:cell "Resources listing" :style "ce-title" :span-columns 6))
	  (clods:with-row (:style "ro-normal" :cell-style "ce-normal")
	    (clods:cells "Ім'я" "Т-IV" "Т-V" "Т-VI" "Т-VII" "Т-VIII"))
	  
	  (let* ((arts-names (art-prefix "keeper" "hell" "morgana" "avalon" "fey"))
		 (arts (mapcar #'(lambda (i) (price-for-sheet i (base "cloth_armor_artifact"))) arts-names)))
	    (loop :for (art-name t4 t5 t6 t7 t8) in arts
		  do (clods:with-row (:style "ro-normal" :cell-style "ce-normal")
		       (clods:cells art-name t4 t5 t6 t7 t8))))

	  (let* ((arts-names (art-prefix "leather morgana" "leather hell"
					 "leather undead" "leather avalon"
					 "leather fey"))
		 (arts (mapcar #'(lambda (i) (price-for-sheet i (base "leather_armor_artifact"))) arts-names)))
	    (loop :for (art-name t4 t5 t6 t7 t8) in arts
		  do (clods:with-row (:style "ro-normal" :cell-style "ce-normal")
		       (clods:cells art-name t4 t5 t6 t7 t8))))

	  (let* ((arts-names (art-prefix "plate undead" "plate hell"
					 "plate keeper" "plate avalon"
					 "plate fey"))
		 (arts (mapcar #'(lambda (i) (price-for-sheet i (base "plate_armor_artifact"))) arts-names)))
	    (loop :for (art-name t4 t5 t6 t7 t8) in arts
		  do (clods:with-row (:style "ro-normal" :cell-style "ce-normal")
		       (clods:cells art-name t4 t5 t6 t7 t8)))))))))
	  
