;;;; albion-data-parser.lisp

(in-package #:albion-data-parser)

;; TODO Навчися парсити json-файли! Базу маєш у загрузках.

(defun %item-base% (&key (item-names *formatted-items*))
  (let ((base (make-hash-table :test 'equal)))
    (mapcar #'(lambda (x) (setf (gethash (second x) base) (first x))) item-names)
    base))


(defun request-name (list-of-names &key (base (%item-base%)))
  (mapcar #'(lambda (x) (gethash x base)) list-of-names))


(defun search-data (data &rest items)
  "Функція, котра витягує дані з json-файла."
  (let ((table (make-hash-table :test 'equal)))
    (labels ((inject-items (list-items)
	       (if (null list-items)
		   table 
		   (if (gethash (car list-items) data)
		       (progn (setf (gethash (car list-items) table) (gethash (car list-items) data)) table
			      (inject-items (cdr list-items)))
		       (inject-items (cdr list-items))))))
      (inject-items items))))


;; Треба доповнити бібліотеку str-tools для заміни пробелів на коми. +
;; Також поправити пусті строки в началі списків +
(defun create-request (&key items (cities *albion-cities*) (qualities 1))
  (let ((api "https://west.albion-online-data.com/api/v2/stats/prices/~A?locations=~A&qualities=~A")
	(formated-cities (txt:insert-divisor "," (txt:split cities)))
	(formated-items  (txt:insert-divisor "," (request-name (txt:split items :delimiter ",")))))
    (format t (concatenate 'string api "~%") formated-items formated-cities qualities)
    (yason:parse (dex:get (format nil api formated-items formated-cities qualities)))))


(defmacro get-items-info (items-names &rest keys)
  `(mapcar #'(lambda (x) (search-data x ,@keys))
	   (create-request :items ,items-names)))

;; Розробити ліпший пошук предметів. Щоб шукало по одному місту. І можна було кинути в функцію/макрос список з містами
;; і він по ньому пробігся видаючи роздільні результати.

(defun find-items (items &key specific-city)
  (let* ((base (get-items-info items "city" "sell_price_min"))
	 (specific-town
	   (if  specific-city
	       (remove-if-not #'(lambda (x) (if (string-equal (gethash "city" x) specific-city) x)) base)
	       base))
	 (prices nil)) ;; Обобщити цю форму!
    (mapcar #'(lambda (x) (push (gethash "sell_price_min" x) prices)) specific-town)
    (nreverse prices)))

(defun prices (id-item city) ; Показує чисту ціну предмета через id
  (mapcar #'car (mapcar #'(lambda (x) (find-items x :specific-city city)) (get-resources-names (by-id id-item)))))

(defun get-for-sheet (item-name city)
  (mapcar #'(lambda (x) (format nil "~A" x))
	  (mapcar #'car (mapcar #'(lambda (x) (find-items x :specific-city city)) (gethash item-name *resources*)))))

(defun list-prices-for-sheet (list-prices)
  (mapcar #'(lambda (x) (format nil "~A" x)) list-prices))



;; Розробити вставлення данних в odt-файл. Цим самим данні будуть сохранятися в табличку. Потім розробити
;; сам файл odt з формулами.
