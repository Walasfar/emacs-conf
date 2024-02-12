;;;; tebot-0.1.lisp
#|
This file contains main-cycle telegram-bot
Functions, for testing
|#
(in-package #:tebot-0.1)


(defun main-cycle ()
  (loop (let ((command (look (%last-message (%request)) "message" "text")))
	  (and (check-base *base-file*)
	       (print "Work...")
	       (unless (string-equal command "exit")
		 (print command))))))

(defun cycle (&key (again t))
  (let ((command (look (%last-message (%request)) "message" "text")))
    (if (and (not (string-equal command "exit")) again)
	(and (format t  "func - ~A, work...~%" command)
	     (sleep 5)
	     (cycle :again t))
	(print "end process!"))))
