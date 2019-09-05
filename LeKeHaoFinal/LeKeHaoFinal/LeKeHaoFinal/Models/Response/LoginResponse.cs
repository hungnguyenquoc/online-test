using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LeKeHaoFinal.Models.Response
{
    public class LoginResponse
    {
        public int Id { get; set; }
        public string Username { get; set; }
        public string Fullname { get; set; }
        public string Token { get; set; } = "";
    }
}
