using AdsRunner.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace AdsRunner.Application.Common.Interfaces;

public interface IApplicationDbContext
{
    DbSet<User> Users { get; }
    DbSet<Campaign> Campaigns { get; }
    DbSet<MediaAsset> MediaAssets { get; }
    DbSet<ScreenDevice> ScreenDevices { get; }
    DbSet<Subscription> Subscriptions { get; }
    DbSet<PaymentRecord> PaymentRecords { get; }
    DbSet<CampaignRegion> CampaignRegions { get; }
    DbSet<CampaignScreen> CampaignScreens { get; }

    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
}
