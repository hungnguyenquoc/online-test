using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LeKeHaoFinal.Models
{
    public class LibContext:DbContext
    {
        public LibContext(DbContextOptions<LibContext> options) : base(options)
        {

        }
        public DbSet<Book> Books { get; set; }
        public DbSet<Checkout> Checkouts { get; set; }

        public DbSet<CheckoutDetail> CheckoutDetails { get; set; }
        public DbSet<Librarian> Librarians { get; set; }
        public DbSet<Member> Members { get; set; }
        public DbSet<Title> Titles { get; set; }

    }
}
