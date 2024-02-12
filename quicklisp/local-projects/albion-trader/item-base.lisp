;;;; item-base.lisp

(in-package #:albion-trader)

(defvar *items* (uiop:read-file-lines "~/.emacs.d/quicklisp/local-projects/albion-trader/items/items.txt"))
(defvar *formatted-items* (mapcar #'(lambda (x) (cdr (txt:split x :delimiter ":"))) *items*))

(defvar *hash-base* (let ((table (make-hash-table :test 'equal))) 
		     (mapcar
		      #'(lambda (item)
			  (setf (gethash (second item) table) (first item)))
		      *formatted-items*)
		      table))

(defvar *cookie-jar* (cl-cookie:make-cookie-jar))
(defvar *albion2d* "https://albiononline2d.com/en/item/id/")
(defvar *resources* '("T2_CLOTH" "T2_LEATHER" "T2_METALBAR" "T2_PLANKS"))

(defvar *ranks* '(2 3
		  4 4.1 4.2 4.3 4.4
		  5 5.1 5.2 5.3 5.4
		  6 6.1 6.2 6.3 6.4
		  7 7.1 7.2 7.3 7.4
		  8 8.1 8.2 8.3 8.4))

(defun art-prefix (&rest class)
  (let ((full-names nil))
    (mapcar
     #'(lambda (x)
	 (setf full-names
	       (append (mapcar #'string-capitalize
			       (list (format nil "head ~A" x)
				     (format nil "armor ~A" x)
				     (format nil "shoes ~A" x)))
		       full-names)))
     class)
    (reverse full-names)))

(defun show-data (item)
  "Просто відображує базу в гарночитаємому виді"
  (and (princ (string #\Newline))
       (maphash #'(lambda (k v) (format t "~A: ~40t~A~%" k v)) item)))


(defmacro with-gensyms ((&rest names) &body body)
  `(let ,(loop for name in names collect `(,name (gensym)))
     ,@body))


(defun compare-names (name item)
  (let ((names (txt:split name))
	(item-name (txt:split item :delimiter "_")))
    (eval `(and ,@(loop for n in names
			collect `(find ,n ',item-name :test 'string-equal))))))

(defun base (item-req-name)
  (get-items-info (txt:insert-divisor "," (car (get-artifact-names item-req-name :id t)))))


(defun find-item (name base)
  (remove-if #'null
	    (mapcar
	     #'(lambda (i)
		 (let ((i-name (gethash "item_id" i))
		       (i-price (gethash "sell_price_min" i)))
		   (when (compare-names name i-name)
		     i-price)))
	     base)))

(defun price-for-sheet (item-name base)
  `(,item-name ,@(mapcar #'(lambda (i) (format nil "~A" i))
			(find-item item-name base))))


