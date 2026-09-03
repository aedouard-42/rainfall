scp -r -P 4242 level9@localhost:/home/user/level9 .



void main(int param_1,int param_2)

{
  N *this;
  N *this_00;
  
  if (param_1 < 2) {
                    /* WARNING: Subroutine does not return */
    _exit(1);
  }
  this = operator.new(0x6c);
  N::N(this,5);
  this_00 = operator.new(0x6c);
  N::N(this_00,6);
  N::setAnnotation(this,*(char **)(param_2 + 4));
  (*(code *)**(undefined4 **)this_00)(this_00,this);
  return;
}

