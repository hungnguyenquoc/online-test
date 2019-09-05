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
    public class LibrarianController : ControllerBase
    {
        private readonly LibContext _context;
        public LibrarianController(LibContext context) {
            _context = context;
            if (_context.Librarians.Count() == 0)
            {
                Librarian adminUSer = new Librarian
                {
                    ACCOUNT = "admin1",
                    PASSWORD = Utils.Helper.GenHash("123456789"),
                    FULLNAME = "Web Admin",
                    CREATEDDATE = DateTime.Now,
                    CREATEDBY = 1
                };
                _context.Librarians.Add(adminUSer);
                _context.SaveChanges();
            }
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
                var aUser = await _context.Librarians.AsNoTracking()
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
                            Id = aUser.LIB_ID,
                            Username = aUser.ACCOUNT,
                            Fullname = aUser.FULLNAME,
                            Token = "Bearer " + tokenString
                        }
                    };

                }
            }
        }

        [HttpGet]
        public async Task<ActionResult<BaseResponse>> GetAll()
        {
            var data = await _context.Librarians.AsNoTracking().ToListAsync();
            return new BaseResponse { Data = data };
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<BaseResponse>> GetOne(int id)
        {
            var data = await _context.Librarians.FirstOrDefaultAsync(x => x.LIB_ID == id);
            if (data != null)
            {

                return new BaseResponse { Data = data };
            }
            return new BaseResponse { ErrorCode = 1, Message = "Not found Data" };
        }

        [HttpPost]
        public async Task<ActionResult<BaseResponse>> Create(Librarian lib)
        {
            _context.Librarians.Add(lib);
            await _context.SaveChangesAsync();
            return new BaseResponse { Data = lib };
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<BaseResponse>> Update(int id, Librarian lib)
        {
            var data = await _context.Librarians.FindAsync(id);
            if (data == null)
            {
                new BaseResponse { ErrorCode = 1, Message = "Not found Data" };
            }
            lib.PASSWORD = Utils.Helper.GenHash(lib.PASSWORD);


            data.ACCOUNT = lib.ACCOUNT;
            data.PASSWORD = lib.PASSWORD;
            data.FULLNAME = lib.FULLNAME;
            data.GENDER = lib.GENDER;
            data.EMAIL = lib.EMAIL;
            data.CREATEDDATE = lib.CREATEDDATE;
            data.PHONE = lib.PHONE;
            data.CREATEDBY = lib.CREATEDBY;



            _context.Librarians.Update(data);
            await _context.SaveChangesAsync();
            return new BaseResponse { Data = data };
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult<BaseResponse>> Delete(int id, Librarian lib)
        {
            var data = await _context.Librarians.FindAsync(id);
            if (data == null)
            {
                return new BaseResponse { ErrorCode = 1, Message = "Not found Data" };
            }

            _context.Librarians.Remove(lib);
            await _context.SaveChangesAsync();
            return new BaseResponse { Data = data };
        }



    }
}