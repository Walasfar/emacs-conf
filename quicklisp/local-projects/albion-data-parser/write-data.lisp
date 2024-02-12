;;;; write-data.lisp

(in-package #:albion-data-parser)


(defun write-example-ods (path)
  (let ((text-props-normal '(:color "#000000" :font-name "Libration Sans" :font-size "12pt"))
	(text-props-title '(:color "#4040c0" :font-name "Times New Roman" :font-size "24pt" :font-weight :bold))
	(text-props-header '(:color "#000000" :font-name "Libration Sans" :font-size "12pt" :font-weight :bold))
	(text-props-link '(:color "#0563c1" :font-name "Libration Sans" :font-size "12pt"
			   :text-underline-style :solid :text-underline-type :single)))
  (clods:with-spreadsheet (path :generator "write-example-ods" :creator "Test User")
    (clods:using-fonts ()
      ;; fonts
      (clods:font "Liberation Sans" :family "Liberation Sans" :family-generic :swiss)
      (clods:font "Times New Roman" :family "Times New Roman" :family-generic :roman))

    (clods:using-styles (:locale (clods:make-locale "FI" #\space 3 #\,))
      ;; number formats
      (clods:number-text-style "n-text")

      ;; cell styles
      (clods:cell-style "ce-normal" nil text-props-normal :data-style "n-text")
      (clods:cell-style "ce-title" "ce-normal" text-props-title :horizontal-align :center)

      ;; column styles

      ;; row styles
      (clods:row-style "ro-normal" nil :height "14pt" :use-optimal-height t)
      (clods:row-style "ro-title" nil :height "24pt" :use-optimal-height t))

    (clods:with-body ()
      (clods:with-table ("Products")
	;; first, define the columns
	(clods:with-header-columns ()
	  (clods:column :style "co-id" :cell-style "ce-int"))
	(clods:column :style "co-name" :cell-style "ce-normal" :repeat 2)
	(clods:column :style "co-number" :cell-style "ce-int")
	(clods:column :style "co-number" :cell-style "ce-frac")
	(clods:column :style "co-number" :cell-style "ce-weight")
	(clods:column :style "co-number" :cell-style "ce-price" :repeat 2)
	(clods:column :style "co-number" :cell-style "ce-perform")
	(clods:column :style "co-date" :cell-style "ce-date")
	(clods:column :style "co-vert" :cell-style "ce-center")

	;; then, add the data row-by-row, starting with headers
	(clods:with-header-rows ()
	  (clods:with-row (:repeat 2)) ; two empty rows at top
	  (clods:with-row (:style "ro-title")
	    (clods:cell "Product listing" :style "ce-title" :span-columns 10)
	    (clods:cell "Any good?" :style "ce-header-vert" :span-rows 4))
	  (clods:with-row ())
	  (clods:with-row (:style "ro-normal")
	    (clods:cells nil nil nil nil nil nil)
	    (clods:cell "Price" :style "ce-header-group" :span-columns 2))
	  (clods:with-row (:style "ro-normal" :cell-style "ce-header-r")
	    (clods:cell "#")
	    (clods:cell "Title" :style "ce-header")
	    (clods:cell "Note" :style "ce-header")
	    (clods:cells "Quantity" "Rating" "Weight" "VAT 0%" "VAT 24%" "Performance" "Availability"))))))))
