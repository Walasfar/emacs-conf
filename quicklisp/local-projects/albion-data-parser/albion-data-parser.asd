;;;; albion-data-parser.asd

(asdf:defsystem #:albion-data-parser
  :description "App for helping you trade and craft in Albion Online"
  :author "Andrew Hoban <c0llapse@tutanota.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:dexador #:lquery #:yason #:str-tools #:clods-export #:local-time)
  :components ((:file "package")
               (:file "albion-data-parser")
	       (:file "write-sheet-data")
	       (:file "albion-data")))
