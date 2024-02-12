(in-package #:tebot-0.1)


(defun %request (&key (api *api*) (token *token*) (method "getUpdates"))
  "Request for api."
  (dex:request (format nil "~A~A/~A" api token method)))


(defun take-data (key data)
  (cdr (assoc key data :test #'string-equal)))


(defun %last-msg (request &key (key "result"))
  (first (reverse
	 (take-data key
		    (yason:parse request :object-as :alist)))))


(defmacro look (data &body names)
  "Take data alist-json structure. And names(keys) return users data and message."
  (let ((tmp nil))
    (dolist (name names)
      (if (null tmp)
	  (and (push data tmp)
	       (setf tmp (append `(take-data ,name) tmp)))
	  (setf tmp (append `(take-data ,name) (list tmp)))))
    tmp))

(defun analyze-msg (data)
  (let ((update-id (look data "update_id"))
	(user-name (look data "message" "from" "username"))
	(id        (look data "message" "from" "id"))
	(text      (look data "message" "text")))
    (list :update-id update-id :user-name user-name :id id :text text)))
    
#|

(defparameter *db*
'(("update_id" . 641161138)
("message" ("message_id" . 110)
  ("from" ("id" . 1471125864) ("is_bot") ("first_name" . "Andrew")
   ("last_name" . "Goban") ("username" . "Andrew_Goban")
   ("language_code" . "ru"))
  ("chat" ("id" . 1471125864) ("first_name" . "Andrew") ("last_name" . "Goban")
   ("username" . "Andrew_Goban") ("type" . "private"))
("date" . 1679728921) ("text" . "Start"))))

Example:
(look *db* "message" "chat" "id")

|#
