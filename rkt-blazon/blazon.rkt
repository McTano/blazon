#lang plai
(require 2htdp/image)


(define WIDTH 200)
(define HEIGHT 200)

;;  field is one-of:
;; -tincture
;; (field->field Field)
;; (on Field (listof Charge))

(define-type Shield
  (Field (tinc image-color?))
  (Upon (field Shield?) (ch Charge?))
  (Tierced-In-Fess (1st Shield?)
                   (2nd Shield?)
                   (3rd Shield?))
  (Per-Fess (top Shield?)
            (bottom Shield?))
  (Per-Pale (left Shield?) (right Shield?))
  (Quarterly (1st Shield?) (2nd Shield?)
             (3rd Shield?) (4th Shield?)))

(define-type Charge
  (Figure (name string?) (tinc image-color?)))

;; Tincture is one-of:
(define or "yellow")
(define gules "red")
(define azure "blue")
(define sable "black")
(define argent "white")
(define purpure "purple")


;(define-type Tincture
; (tincture (name string?)))
(define (tincture str)
  (square HEIGHT "solid" str))


(define-type Dimensions
  (dim (width real?) (height real?) (font-size real?)))

(define init-dims (dim HEIGHT WIDTH 20))


(define (d/ dims divisor)
  (type-case Dimensions dims
    (dim (width height font-size)
         (dim (/ width divisor)
              (/ height divisor)
              (/ font-size divisor)))))

(define (avg a b)
  (/ (+ a b) 2))

(define (d/xy dims x y)
  (type-case Dimensions dims
    (dim (width height font-size)
         (dim (/ width x)
              (/ height y)
              (/ font-size (avg x y))))))


(define (draw-charge ch dims)
  (type-case Charge ch
    (Figure (name tinc)
            (overlay
             (text name 20 "black")
             (rectangle (dim-width dims)
                        (dim-height dims)
                        "solid" tinc)
             ))))

(define (draw-shield shield)
  (local [(define (draw-shield-helper shield dims)
   (type-case Shield shield
    (Field (tinc) (rectangle (dim-width dims) (dim-height dims) "solid" tinc))
    (Upon (sub-shield ch) (overlay (draw-charge ch (d/ dims 2))
                                   (draw-shield-helper sub-shield dims)))
     (Tierced-In-Fess (1st 2nd 3rd) (above (draw-shield-helper 1st (d/xy dims 1 3))
                                           (draw-shield-helper 2nd (d/xy dims 1 3))
                                           (draw-shield-helper 3rd (d/xy dims 1 3))))
     (Per-Fess (top bottom) (above (draw-shield-helper top (d/xy dims 1 2))
                                   (draw-shield-helper bottom (d/xy dims 1 2))))
     (Per-Pale (left right) (beside (draw-shield-helper left (d/xy dims 2 1))
                                   (draw-shield-helper right (d/xy dims 2 1))))
     (Quarterly (1st 2nd 3rd 4th) (draw-shield-helper (Per-Fess
                                                       (Per-Pale 1st 2nd)
                                                       (Per-Pale 3rd 4th))) dims)))]
    (draw-shield-helper shield init-dims)))

(define SCOTLAND (Upon (Field or) (Figure "lion" gules)))
(define LEOPARD (Upon (Field gules) (Figure "lion" or)))
(define ENGLAND (Tierced-In-Fess LEOPARD LEOPARD LEOPARD))
(define IRELAND (Upon (Field azure) (Figure "harp" or)))
(define QUEBEC (Upon (Field azure) (Figure "fleurs-de-lis" argent)))
(define MAPLE-LEAVES (Upon (Field argent) (Figure "maple-leaves" gules)))
(draw-shield (Tierced-In-Fess (Per-Pale ENGLAND SCOTLAND)
                              (Per-Pale IRELAND QUEBEC)
                              MAPLE-LEAVES))



(define OR (tincture "yellow"))
(define GULES (tincture "red"))
(define AZURE (tincture "blue"))
(define SABLE (tincture "black"))
(define ARGENT (tincture "white"))
(define PURPURE (tincture "purple"))


(define (per-fess top-color bottom-color)
  (above (scale/xy 1 1/2 top-color)
         (scale/xy 1 1/2 bottom-color)))

(define (per-pale top-color bottom-color)
  (beside (scale/xy 1/2 1 top-color)
         (scale/xy 1/2 1 bottom-color)))

(define (quartered first second third fourth)
  [per-fess (per-pale first second)
            (per-pale third fourth)]
  )

(define quarterly quartered)

(define (top-half image)
  (scale/xy 1 2 (crop 0
        0
        (image-width image)
        (/ (image-width image) 2)
        image)))

(define (bottom-half image)
  (scale/xy 1 2 (crop 0
        (/ (image-height image) 2)
        (image-width image)
        (/ (image-height image) 2)
        image)))

(define (the-first-and-second-containing field)
  (list (top-half field)
        (bottom-half field)))


; (per-fess ARGENT AZURE)

; (quartered SABLE AZURE PURPURE ARGENT)

(define (tierced-in-fess first second third)
  (above (scale/xy 1 1/3 first)
         (scale/xy 1 1/3 second)
         (scale/xy 1 1/3 third)))

(define CANADA (apply tierced-in-fess
                (append (the-first-and-second-containing
                 (quarterly GULES OR AZURE PURPURE))
                 (list ARGENT))))

CANADA

(define (a charge) charge)
(define (two charge) (list charge charge))
(define (three charge) (list charge charge charge))