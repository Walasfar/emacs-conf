#|
Contains functions for work with base. Controll functions
and parsing data.
|#


(in-package #:tebot-0.1)


(defparameter *base* (make-hash-table :test #'equal))
(defvar *base-file* (pathname "users-chat-id"))


(defun mutate-base (file-base)
  (with-open-file (out file-base :direction :output
				 :if-exists :supersede)
    (with-standard-io-syntax
      (print *base* out))))


(defun load-base (file-base)
  (with-open-file (in file-base)
    (with-standard-io-syntax
      (setf *base* (read in)))))


(defun add-new-user (user-name id update-id base)
  (unless (gethash user-name base)
    (setf (gethash user-name base) (list :id id :update-id update-id))
    (mutate-base *base-file*)))


(defun update-user-data (user-name update-id base &key (file-base #P"users-chat-id"))
  (let ((old-id (getf (gethash user-name base) :update-id)))
    (if old-id
	(and (not (= update-id old-id))
	     (setf (getf (gethash user-name base) :update-id) update-id)
	     (mutate-base base)))))


(defun check-base (file-base)
  (cond
    ((probe-file file-base) (load-base file-base))
    (t (mutate-base file-base))))
