;; window size
(if window-system
  (progn
    (add-to-list 'default-frame-alist
         (cons 'height 400))
    (add-to-list 'default-frame-alist
         (cons 'width 300))))
