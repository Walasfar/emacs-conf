;;;; requests.lisp

(in-package #:albion-trader)

(defvar *api*
  "https://~A.albion-online-data.com/api/v2/stats/prices/~A?locations=~A&qualities=1"
  "https://west.albion-online-data.com/api/v2/stats/prices/T4_BAG,T5_BAG?locations=Caerleon,Bridgewatch&qualities=0")
(defvar *albion2d*
  "https://albiononline2d.com/en/item/id/~A")


(defun get-items-info (items &key (adress *api*) (server "west") (cities "Caerleon"))
  "Examples:
items - 'T2_BAG,T4_BAG,T4_CLOTH'
cities - 'Bridgewatch, Caerleon, FortSterling, Lumhusrt, Martlock, Thetford'
server - west, east"
  (let ((request (format nil adress server items cities))) ; create string adress
    (multiple-value-bind (content status jun1 jun2 nothing) (dex:get request)
      (declare (ignore jun1 jun2 nothing)) ; parse data
      (if (= status 200)
	  (yason:parse content) ; prase .json
	  (error "No response! No network? Or server 404.")))))


(defun albion2d-search (id &key (api *albion2d*))
  "Для пошуку в albion2d базі"
  (format nil "~A~A" api id))

(defun %name-to-id% (name &key (base *hash-base*))
  "Бере людське ім'я предмета та повертає id предмета. Корисно при людському пошуці. Або парсингу"
  (gethash name base))

(defun normalize-name (name)
  (let ((coerced-name (txt:split name :delimiter "_")))
    (format nil "T~A_~A"
	    (1+ (parse-integer (car coerced-name) :start 1 :junk-allowed t))
	    (txt:insert-divisor "_" (cdr coerced-name)))))

(defun normalize-duplicate (list)
  (let ((normal-list (copy-list list)))
    (labels ((evolve-item (lst)
	       (if lst
		   (if (string-equal (first lst) (second lst))
		       (progn
			 (setf (nth (1+ (position (first lst) normal-list :test 'string-equal)) normal-list)
			       (normalize-name (second lst))))
		       (evolve-item (cdr lst))))))
      (evolve-item list))
    normal-list))


(defun get-resource-names (resource-id)
  "Всі назви ресурсів для доступа в базу"
  (let ((response (dex:get resource-id)))
    (when response
      (lquery:$ (initialize response))
      (coerce (lquery:$ ".card-box a img" (:attr "title")) 'list))))


(defun get-artifact-names (artifact-id &key id)
  "Повертає всі назви артефактів вибраного виду"
  (let ((response (dex:get
		   (format nil "https://wiki.albiononline.com/wiki/~A" artifact-id)
		   :cookie-jar *cookie-jar*)))
    (lquery:$ (initialize response))
    (let ((art-and-item (coerce (lquery:$ ".wikitable a" (:attr "title")) 'list))
	  (arts nil)
	  (items nil))
      (dolist (object art-and-item)
	(if (evenp (position object art-and-item :test 'string-equal))
	    (push object items)
	    (push object arts)))
      (if id
	  (nreverse (list
		     (mapcar #'%name-to-id% (nreverse arts))
		     (normalize-duplicate  (mapcar #'%name-to-id% (nreverse items)))))
	  (nreverse (list
		     (nreverse arts)
		     (nreverse items)))))))

(defun res-prices (res-name)
  (let ((data (dex:get (albion2d-search res-name))))
    (lquery:$ (initialize data))
    (mapcar
     #'(lambda (x)
	 (format nil "~A" (gethash "sell_price_min" x)))
     (get-items-info
      (txt:insert-divisor ","
			  (remove-duplicates
			   (mapcar #'%name-to-id% (coerce (lquery:$ ".card-box img" (:attr "title")) 'list))
			   :from-end t
			   :test 'string-equal))))))
