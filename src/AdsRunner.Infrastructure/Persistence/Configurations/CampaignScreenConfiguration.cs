using AdsRunner.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace AdsRunner.Infrastructure.Persistence.Configurations;

public class CampaignScreenConfiguration : IEntityTypeConfiguration<CampaignScreen>
{
    public void Configure(EntityTypeBuilder<CampaignScreen> builder)
    {
        builder.ToTable("CampaignScreens");

        builder.HasKey(cs => cs.Id);
        builder.Property(cs => cs.Id).HasDefaultValueSql("NEWSEQUENTIALID()");

        builder.HasIndex(cs => cs.CampaignId);
        builder.HasIndex(cs => cs.ScreenDeviceId);
        builder.HasIndex(cs => new { cs.CampaignId, cs.ScreenDeviceId }).IsUnique();
    }
}
