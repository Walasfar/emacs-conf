(in-package #:albion-data-parser)

(defun gen-func ()
  (let ((command "=($C$2*(HLOOKUP($B$2, 'file:///home/walafar/Documents/test.ods'#$Resources.$B$3:$E$30,~S,0))+$C$3*(HLOOKUP($B$3, 'file:///home/walafar/Documents/test.ods'#$Resources.$B$3:$E$30,~S,0)))~%"))
    (do ((i 2 (incf i)))
	((> i 28) 'end)
      (format t command i i))))
