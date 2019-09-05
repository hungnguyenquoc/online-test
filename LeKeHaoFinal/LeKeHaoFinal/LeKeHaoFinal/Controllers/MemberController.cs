using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using LeKeHaoFinal.Models;
using LeKeHaoFinal.Models.Request;
using LeKeHaoFinal.Models.Response;
using LeKeHaoFinal.Utils;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace LeKeHaoFinal.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class MemberController : ControllerBase
    {
        private readonly LibContext _context;
        public MemberController(LibContext context)
        {
            _context = context;
            if (_context.Members.Count() == 0)
            {
                Member adminUSer = new Member
                {
                    ACCOUNT = "admin",
                    PASSWORD = Utils.Helper.GenHash("123456"),
                    FULLNAME = "Web Admin",
                    CREATEDDATE = DateTime.Now,
                    CREATEDBY=1
            };
                _context.Members.Add(adminUSer);
                _context.SaveChanges();
            }
        }

        [HttpGet]
        public async Task<ActionResult<BaseResponse>> GetAll()
        {
            var data = await _context.Members.AsNoTracking().ToListAsync();
            return new BaseResponse { Data = data };
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public async Task<ActionResult<BaseResponse>> Login(LoginRequest req)
        {
            if (String.IsNullOrEmpty(req.Username) || String.IsNullOrEmpty(req.Password))
            {
                return new BaseResponse
                {
                    ErrorCode = 1,
                    Message = "Missing Field(s)"
                };
            }
            else
            {
                var aUser = await _context.Members.AsNoTracking()
                    .FirstOrDefaultAsync(x =>
                    x.ACCOUNT == req.Username && x.PASSWORD == Utils.Helper.GenHash(req.Password));
                if (aUser == null)
                {
                    return new BaseResponse
                    {
                        ErrorCode = 2,
                        Message = "wrong user name or password"
                    };
                }
                else
                {
                    var claimData = new[] { new Claim(ClaimTypes.Name, req.Username) };
                    var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Helper.AppKey));
                    var signingCredential = new SigningCredentials(key,
                                   SecurityAlgorithms.HmacSha256
                        );
                    var token = new JwtSecurityToken
                        (
                            issuer: Helper.Issuer,
                            audience: Helper.Issuer,
                            expires: DateTime.Now.AddDays(1),
                            claims: claimData,
                            signingCredentials: signingCredential
                        );
                    var tokenString = new JwtSecurityTokenHandler().WriteToken(token);
                    return new BaseResponse
                    {
                        Message = "Success",
                        Data = new LoginResponse
                        {
                            Id = aUser.MEM_ID,
                            Username = aUser.ACCOUNT,
                            Fullname = aUser.FULLNAME,
                            Token = "Bearer " + tokenString
                        }
                    };
                    
                }
            }
        }
    }
}