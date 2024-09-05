#let special_version = read("./version.txt")
#align(center, [
    #v(2em)
    #[#set par(justify: true)
    #image("img/logo-black.png", width: 120pt)]
    #set text(size:18pt)

    Oracle Specifications
    #align(center, text(12pt, weight: 400)[
        v. #special_version
    ])

    #datetime.today().display("[day] [month repr:long], [year]")
])
#v(2em)
= GEMA Oracle Specification

== Overview
This specification outlines the Greater Exponential Moving Average (GEMA) oracle algorithm, designed to provide a responsive and adaptive measure of asset price trends. It is particularly suited for financial applications requiring quick reactions to market downturns while maintaining stability during upward trends.

== Algorithm Description
The GEMA algorithm uses a single piece of previous state to add a drag for price increases while immediately reflecting decreases. This approach combines quick responsiveness to potential losses with the stability of trend following during growth periods.

== Key Features
1. Immediate reflection of price decreases
2. Smoothed response to price increases using GEMA calculation
3. Single state variable for efficient implementation

== Implementation Details

=== Inputs
- `prices`: A list of asset prices over time
- `period`: The number of days for the GEMA calculation (default: 20)

=== Output
- A list of GEMA values corresponding to the input prices

== Visual Representation

#figure(
  image("img/example.png", width: 80%),
  caption: [
    Comparison of Asset Price and GEMA over time. 
    The red line represents the GEMA, which quickly adapts to price decreases while smoothing price increases.
  ]
)

This graph demonstrates how the GEMA (red line) closely follows the asset price (blue line) during downward movements, while providing a smoother trend during upward movements.

=== Algorithm
$f(t) = min {
  gamma dot f(t-1) + (1-gamma) x_t,
  x_t
}$

==== Pseudocode
#align(left)[
  #set text(font: "New Computer Modern Mono")
  #set par(leading: 0.65em)
  #let prices = [...price values]

  #table(
    columns: (auto, auto),
    inset: 0pt,
    stroke: none,
    align: left + horizon,
    [*Input:*], [prices, period],
    [*Output:*], [gema],
  )

  #v(0.5em)
  $"gema" arrow.l [prices[0]]$\
  $"multiplier" arrow.l 2 / ("period" + 1)$\
  #v(0.5em)
  *for* $"price"$ *in* $"prices"[1:]$ *do*\
    #h(1em) *if* $"price" < "gema"[-1]$ *then*\
      #h(2em) $"gema"."append"("price")$\
    #h(1em) *else*\
      #h(2em) $"new_gema" arrow.l ("price" - "gema"[-1]) dot "multiplier" + "gema"[-1]$\
      #h(2em) $"gema"."append"("new_gema")$\
    #h(1em) *end if*\
  *end for*
  #v(0.5em)
  *return* $"gema"$
]

== Notes
1. The algorithm initializes the GEMA with the first price in the series.
2. For each subsequent price:
   - If the new price is lower than the previous GEMA, it immediately becomes the new GEMA value.
   - If the new price is higher, a standard GEMA calculation is applied.
3. This approach ensures quick adaptation to price drops while smoothing out price increases.

== Reference Implementation
For a reference implementation, refer to the `calculate_gema` function in the `oracles.py` file.
