;;;; str-tools.lisp

(in-package #:str-tools)

(defun separate-words (text delimiter)
  "Take text and return multiple values. First value first word, second value rest of string."
  (if (find delimiter text :test #'string-equal)
      (let ((first-word (subseq text  0  (position delimiter text :test #'string-equal)))
	    (rest-words (subseq text (1+ (position delimiter text :test #'string-equal)))))
	(values (string-trim '(#\Space) first-word)
		(string-trim '(#\Space) rest-words)))
      (values text nil)))


(defun split (text &key (delimiter #\Space))
  "Take text and delimiter (space by default) and return list of words."
  (let (tmp)
    (labels
	((iter (text)
	   (multiple-value-bind (word rest-words)
	       (separate-words text delimiter)
	     (if rest-words
		 (and (push word tmp)
		      (iter rest-words))
		 (push word tmp)))))
      (iter text))
    (remove-if #'(lambda (x) (string-equal x "")) (nreverse tmp))))

(defun insert-divisor (divisor list-of-words) ; FOR EXPORT!
  "Принимает разделитель и список слов, возвращает строку с разделителями-
пробелами делящими слова. Если не хотите делить, а просто обьединить -
передайте пустую строку."
  (with-output-to-string (s)
    (dolist (i list-of-words)
      (if (not (string= i (car (last list-of-words))))
	  (format s "~A~A" i divisor)
	  (format s "~A" i)))))
