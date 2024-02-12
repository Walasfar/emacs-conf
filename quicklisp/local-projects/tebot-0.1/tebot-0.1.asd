;;;; tebot-0.1.asd

(asdf:defsystem #:tebot-0.1
  :description "Tebot help you make your own telegram bot and write new functionality."
  :author "Andrii Hoban"
  :license  "Specify license here"
  :version "0.1"
  :serial t
  :depends-on (#:dexador #:yason #:str-tools)
  :components ((:file "package")
	       (:file "api")
	       (:file "requests")
	       (:file "mind")
               (:file "tebot-0.1")))
