;;; +modeline.el -*- lexical-binding: t; -*-

(after! doom-modeline
  ;; Set custom modal icon here
  ;; (setq modal-icon-active "⭑૮​​​​･​​​ﻌ​​･​​​ა​​​⭑")
  (setq modal-icon-active   "૮​​​​･​​​​​ﻌ​​​​･​​​​​ა​​​⋆")
  (setq modal-icon-inactive "૮​​​–​​​​ﻌ​​​​–​​​აᷦᷦᷦ")

  ;; Enable Unicode fallback
  (setq doom-modeline-unicode-fallback t)

  ;; Override definition in doom-modeline-segments.el
  (defun doom-modeline--modal-icon (text face help-echo &optional icon unicode)
  "Display the model icon with FACE and HELP-ECHO.
TEXT is alternative if icon is not available."
    (propertize (doom-modeline-icon
                 'mdicon
                 (when doom-modeline-modal-icon "") ;; Trigger fallback by providing empty string
                 (if (doom-modeline--active)
                     (pcase text
                       ;; (" <N> " "⋆૮​​​​･​​​​​ﻌ​​​​･​​​​​ა​​​⋆")
                       (" <N> " "૮​​​​･​​​​​ﻌ​​​​･​​​​​ა​​​⭑")
                       (" <I> " "૮​​​​･​​​​​ﻌ​​​​･​​​​​ა​✎")
                       ((or " <V> " " <Vl> " " <Vb> ") "૮​​​​･​​​​​ﻌ​​​​･​​​​​ა​⚑")
                       (" <R> " "૮​​​​･​​​​​ﻌ​​​​･​​​​​ა​⚠")
                       (" <O> " "૮​​​​･​​​​​ﻌ​​​​･​​​​​ა​…"))
                   modal-icon-inactive)
                 text ;; Ascii fallback
                 :face (doom-modeline-face face)
                 ;; :v-adjust -0.225)
                 :v-adjust -1)
                 'help-echo help-echo)))
