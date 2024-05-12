import pandas as pd
import matplotlib.pyplot as plt

week_charge = pd.read_csv('./analysis/week wise charge.csv')
week_discharge = pd.read_csv('./analysis/week wise discharge.csv')
month_charge = pd.read_csv('./analysis/month wise charge.csv')
month_discharge = pd.read_csv('./analysis/month wise discharge.csv')

fig, axs = plt.subplots(2, 2, constrained_layout=True, dpi=100, figsize=(14, 7))
fig.suptitle('Charge v/s Discharge')

axs[0,0].set_title('Month wise charge')
ax1 = axs[0,0].twinx()
axs[0,0].plot(month_charge['month'], month_charge['battery charged'], color='red', lw=3)
ax1.plot(month_charge['month'], month_charge['time taken'], color='blue', lw=3)

axs[0,1].set_title('Month wise discharge')
ax2 = axs[0,1].twinx()
axs[0,1].plot(month_discharge['month'], month_discharge['battery down'], color='red', lw=3)
ax2.plot(month_discharge['month'], month_discharge['down time'], color='blue', lw=3)

axs[1,0].set_title('week wise charge')
ax3= axs[1,0].twinx()
axs[1,0].plot(week_charge['week'], week_charge['battery charged'], color='red', lw=3)
ax3.plot(week_charge['week'], week_charge['time taken'], color='blue', lw=3)

axs[1,1].set_title('week wise discharge')
ax4 = axs[1,1].twinx()
axs[1,1].plot(week_discharge['week'], week_discharge['battery down'], color='red', lw=3)
ax4.plot(week_discharge['week'], week_discharge['down time'], color='blue', lw=3)

plt.savefig('charge - discharge.png')
