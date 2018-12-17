use Class::Struct;

struct(Node => { value => '$', nxt => '$', prev => '$' });

my $tmp = Node->new(value => 3, nxt => '', prev => '');
my $elf1 = \$tmp;
my $tmp = Node->new(value => 7, nxt => $elf1, prev => $elf1);
my $elf2 = \$tmp;
$$elf1->nxt($elf2);
$$elf1->prev($elf2);
my $tail = $elf2;

my $needed = <STDIN>;
chomp($needed);
my @sequence = split(//, $needed);
my $length = @sequence;

sub getNewRecipes {
    use List::Util qw(sum);
    my $sum = sum(@_);
    return split(//, "$sum");
}

sub walk {
    my $elf = @_[0];
    my $dist = $$elf->value;
    for (my $i = 0; $i <= $dist; $i++) {
        $elf = $$elf->nxt;
    }
    return $elf;
}

sub insert {
    my $toIns = @_[0];
    my $after = @_[1];

    $$toIns->prev($after);
    $$toIns->nxt($$after->nxt);
    ${$$after->nxt}->prev($toIns);
    $$after->nxt($toIns);

    return $toIns;
}

sub endsWith {
    my $curr = @_[0];
    my @seq = @{@_[1]};
    
    for (my $i = -1; $i >= -@seq; $i--) {
      return unless $$curr->value == @seq[$i];
      $curr = $$curr->prev;
    }

    return 1;
}

my $toLeft = -1;
my $ct = 2;
while ($toLeft == -1){
    my @newRecipes = getNewRecipes($$elf1->value, $$elf2->value); 
    for (my $i = 0; $i < @newRecipes; $i++) {
        my $toIns = Node->new(value => @newRecipes[$i]);
        $tail = insert(\$toIns, $tail);
        $ct++;
    }
    my $i = 0;
    $elf1 = walk($elf1);
    $elf2 = walk($elf2);
    if (endsWith($tail, \@sequence) == 1) {
        $toLeft = $ct - $length;
    }
    if (endsWith($$tail->prev, \@sequence) == 1) {
        $toLeft = $ct - $length - 1;
    }
}

print "$toLeft\n";
