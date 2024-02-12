(in-package #:albion-data-parser)

(defvar *items* (uiop:read-file-lines "~/.emacs.d/quicklisp/local-projects/albion-data-parser/items/items.txt"))

(defvar *formatted-items* (mapcar #'(lambda (x) (cdr (txt:split x :delimiter ":"))) *items*))

(defvar *albion-cities* "Bridgewatch Caerleon FortSterling Lymhurst Martlock Thetford"
  "Caerleon Bridgewatch FortSterling BlackMarket Lymhurst Martlock Thetford")

(defvar *albion-2d* "https://albiononline2d.com/en/item/id/")

(defvar *ranks* '(2 3
		  4 4.1 4.2 4.3 4.4
		  5 5.1 5.2 5.3 5.4
		  6 6.1 6.2 6.3 6.4
		  7 7.1 7.2 7.3 7.4
		  8 8.1 8.2 8.3 8.4))

(defun get-resources-names (adress)
  (let* ((response (dex:get adress)))
    (when response
      (lquery:$ (initialize response))
      (coerce (lquery:$ ".card-box a img" (:attr "title")) 'list))))

(defun get-items-by-type (adress)
  (let* ((response (dex:get adress)))
    (when response
      (lquery:$ (initialize response))
      (coerce (lquery:$ ".wid-u-info" (text)) 'list))))


(defun by-id (id &key (api *albion-2d*))
  (concatenate 'string api id))

(defun specific-name (list-names)
  (let ((item (car list-names)))
    (subseq item (1+ (position " " item :test #'string-equal)))))

(defun info-for-sheets (id-item-name id-artefact-name)
  (let ((item-name (specific-name (get-resources-names (by-id id-item-name))))
	(artefact-name (get-resources-names (by-id id-artefact-name))))
    (list item-name artefact-name))) ; написати щось що верне `(,item-name ,@prices)


(defun resources ()
  (let* ((titles '("Leather" "Cloth" "Planks" "Metalbars"))
	 (id '("T2_LEATHER" "T2_CLOTH" "T2_PLANKS" "T2_METALBAR"))
	 (adress (mapcar #'by-id id))
	 (hex-data (make-hash-table :test 'equal)))
    (dotimes (i (length titles))
      (setf (gethash (nth i titles) hex-data) (get-resources-names (nth i adress))))
    hex-data))

(defun refact-item-name (item)
  (subseq item (1+ (position #\Space item :test #'string=))))

(defvar  *resources* (resources))

;; druid armor   T4_ARTEFACT_ARMOR_CLOTH_KEEPER
;; druid helmet  T4_ARTEFACT_HEAD_CLOTH_KEEPER
;; druid shoes   T4_ARTEFACT_SHOES_CLOTH_KEEPER

(defun find-specific-item (material type class &key (city "Caerleon"))
  (let ((up-class    (string-upcase class))
	(up-type     (string-upcase type))
	(up-material (string-upcase material)))
    (prices (format nil "T4_ARTEFACT_~A_~A_~A" up-type up-material up-class) city)))

(defvar *cloth-armor*
  (mapcar #'refact-item-name
	  (cdddr (get-items-by-type "https://albiononline2d.com/en/item/cat/armor/subcat/cloth_armor?tier=4&enchantment=1"))))
(defvar *cloth-helmet*
  (mapcar #'refact-item-name
	  (cdddr (get-items-by-type "https://albiononline2d.com/en/item/cat/armor/subcat/cloth_helmet?tier=4&enchantment=1"))))
(defvar *cloth-shoes*
  (mapcar #'refact-item-name
	  (cdddr (get-items-by-type "https://albiononline2d.com/en/item/cat/armor/subcat/cloth_shoes?tier=4&enchantment=1"))))
