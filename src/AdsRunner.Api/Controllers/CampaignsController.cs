using AdsRunner.Application.Common.Interfaces;
using AdsRunner.Application.DTOs;
using AutoMapper;
using AutoMapper.QueryableExtensions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AdsRunner.Api.Controllers;

[ApiController]
[Route("api/v1/[controller]")]
[Authorize]
public class CampaignsController : ControllerBase
{
    private readonly IApplicationDbContext _context;
    private readonly IMapper _mapper;

    public CampaignsController(IApplicationDbContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    [HttpGet]
    public async Task<ActionResult<List<CampaignSummaryDto>>> GetAll(CancellationToken cancellationToken)
    {
        var campaigns = await _context.Campaigns
            .OrderByDescending(c => c.CreatedAt)
            .ProjectTo<CampaignSummaryDto>(_mapper.ConfigurationProvider)
            .ToListAsync(cancellationToken);

        return Ok(campaigns);
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<CampaignDto>> GetById(Guid id, CancellationToken cancellationToken)
    {
        var campaign = await _context.Campaigns
            .Include(c => c.MediaAssets)
            .Include(c => c.CampaignRegions)
            .FirstOrDefaultAsync(c => c.Id == id, cancellationToken);

        if (campaign is null)
            return NotFound();

        return Ok(_mapper.Map<CampaignDto>(campaign));
    }
}
