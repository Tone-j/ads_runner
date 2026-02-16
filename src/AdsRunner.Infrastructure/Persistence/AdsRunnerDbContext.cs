using AdsRunner.Application.Common.Interfaces;
using AdsRunner.Domain.Common;
using AdsRunner.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace AdsRunner.Infrastructure.Persistence;

public class AdsRunnerDbContext : DbContext, IApplicationDbContext
{
    public AdsRunnerDbContext(DbContextOptions<AdsRunnerDbContext> options)
        : base(options)
    {
    }

    public DbSet<User> Users => Set<User>();
    public DbSet<Campaign> Campaigns => Set<Campaign>();
    public DbSet<MediaAsset> MediaAssets => Set<MediaAsset>();
    public DbSet<ScreenDevice> ScreenDevices => Set<ScreenDevice>();
    public DbSet<Subscription> Subscriptions => Set<Subscription>();
    public DbSet<PaymentRecord> PaymentRecords => Set<PaymentRecord>();
    public DbSet<CampaignRegion> CampaignRegions => Set<CampaignRegion>();
    public DbSet<CampaignScreen> CampaignScreens => Set<CampaignScreen>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(AdsRunnerDbContext).Assembly);
        base.OnModelCreating(modelBuilder);
    }

    public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
    {
        var now = DateTime.UtcNow;

        foreach (var entry in ChangeTracker.Entries<BaseEntity>())
        {
            switch (entry.State)
            {
                case EntityState.Added:
                    entry.Entity.CreatedAt = now;
                    entry.Entity.UpdatedAt = now;
                    if (entry.Entity.Id == Guid.Empty)
                        entry.Entity.Id = Guid.NewGuid();
                    break;
                case EntityState.Modified:
                    entry.Entity.UpdatedAt = now;
                    break;
            }
        }

        return base.SaveChangesAsync(cancellationToken);
    }
}
