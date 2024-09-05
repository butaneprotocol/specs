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
= Simple EMA Oracle Specification

== Overview
This specification outlines the Simple Exponential Moving Average (EMA) oracle algorithm, which is designed to provide a responsive and adaptive measure of asset price trends. The algorithm is particularly suited for financial applications where quick reactions to market downturns are crucial while maintaining stability during upward trends.

== Algorithm Description
The Simple EMA algorithm uses a single piece of previous state to add a drag for any price increases while immediately reflecting price decreases. This approach combines the benefits of quick responsiveness to potential losses with the stability of trend following during growth periods.

== Key Features
1. Immediate reflection of price decreases
2. Smoothed response to price increases using EMA calculation
3. Single state variable for efficient implementation

== Implementation Details

=== Inputs
- `prices`: A list of asset prices over time
- `period`: The number of days for the EMA calculation (default: 20)

=== Output
- A list of EMA values corresponding to the input prices

== Visual Representation

The following graph illustrates the behavior of the Simple EMA algorithm compared to the actual price of an asset over time:

#figure(
  image("img/example.png", width: 80%),
  caption: [
    Comparison of Asset Price and Simple EMA over time. 
    The red line represents the Simple EMA, which quickly adapts to price decreases while smoothing price increases.
  ]
)

This visual representation demonstrates how the Simple EMA (red line) closely follows the asset price (blue line) during downward movements, while providing a smoother trend during upward movements. This behavior aligns with the algorithm's design to be responsive to potential losses while maintaining stability during growth periods.


=== Pseudocode

#figure([
  #set text(font: "New Computer Modern Mono")

  *Input:* prices, period \
  *Output:* ema

  ema \<\- [prices[0]] \
  multiplier \<\- 2 / (period + 1)

  *for* price *in* prices[1:] \
  #h(20pt)*if* price < ema[-1] \
  #h(40pt)ema.append(price) \
  #h(20pt)*else* \
  #h(40pt)new_ema \<\- (price - ema[-1]) \* multiplier + ema[-1] \
  #h(40pt)ema.append(new_ema) \
  #h(20pt)*end if* \
  *end for*

  *return* ema
], caption: "Simple EMA Algorithm")

== Notes
1. The algorithm initializes the EMA with the first price in the series.
2. For each subsequent price:
   - If the new price is lower than the previous EMA, it immediately becomes the new EMA value.
   - If the new price is higher, a standard EMA calculation is applied.
3. This approach ensures quick adaptation to price drops while smoothing out price increases.

== Reference Implementation
For a reference implementation, refer to the `calculate_simple_ema` function in the `oracles.py` file.
