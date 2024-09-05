import matplotlib.pyplot as plt
import numpy as np

def generate_price_data(initial_price, num_days, volatility):
    """Generate price data using random walk."""
    prices = [initial_price]
    for _ in range(num_days - 1):
        change = np.random.normal(0, volatility)
        new_price = max(0, prices[-1] + change)  # Ensure price doesn't go negative
        prices.append(new_price)
    return prices

def calculate_modified_ema(prices, period=20):
    """Calculate Modified Exponential Moving Average."""
    ema = [prices[0]]
    multiplier = 2 / (period + 1)
    for price in prices[1:]:
        if price < ema[-1]:
            ema.append(price)  # Immediately adjust to price decrease
        else:
            ema.append((price - ema[-1]) * multiplier + ema[-1])  # Use EMA for price increase
    return ema

def calculate_simple_ema(prices, period=20):
    """
    Calculate Simple Exponential Moving Average with immediate price decrease reflection.
    
    This is the preferred model for our analysis. It has the following characteristics:
    1. Immediately adjusts to price decreases, providing quick responsiveness to market downturns.
    2. Uses standard EMA calculation for price increases, allowing for a smoother trend during upward movements.
    
    This combination allows for quick reaction to potential losses while maintaining trend stability during growth periods.
    """
    ema = [prices[0]]
    multiplier = 2 / (period + 1)
    for price in prices[1:]:
        if price < ema[-1]:
            ema.append(price)  # Immediately adjust to price decrease
        else:
            ema.append((price - ema[-1]) * multiplier + ema[-1])  # Use EMA for price increase
    return ema

def plot_asset_price(asset_name, initial_price=100, num_days=365, volatility=1):
    """Plot the price of an asset over time."""
    days = range(num_days)
    prices = generate_price_data(initial_price, num_days, volatility)
    simple_ema = calculate_simple_ema(prices)
    
    plt.figure(figsize=(10, 6))
    plt.plot(days, prices, label='Price')
    plt.plot(days, simple_ema, label='Simple EMA (Preferred Model)', color='red')
    plt.title(f"Price of {asset_name} Over Time")
    plt.xlabel("Days")
    plt.ylabel("Price")
    plt.grid(True)
    plt.legend()
    plt.savefig('img/example.png')
    plt.close()

# Example usage
plot_asset_price("XYZ", initial_price=100, num_days=365, volatility=1)
